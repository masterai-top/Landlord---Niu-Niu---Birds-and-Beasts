%%%-----------------------------------
%%% @Module  : game_server_reader
%%% @Author  : smyx_game
%%% @Created : 2013.07.10
%%% @Description: 客户端 
%%%-----------------------------------
-module(game_server_reader).
-export([start_link/0, init/0, test/0, routing/3]).

-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").

%%记录客户端进程
-record(client, {
    player_pid = undefined,  %%玩家进程
    player_id = 0,        %%玩家id
    login = 0,                 %%是否登陆成功
    login_ip = [],        %%玩家ip
    account_id = undefined,    %%玩家平台id
    account_name = undefined,  %%玩家平台用户名
    account_type = undefined,   %%平台类型
    seq = 0,                    %%客户端发的序列号
    timeout = 0                 %超时次数
}).

start_link() ->
    {ok, proc_lib:spawn_link(?MODULE, init, [])}.

%%gen_server init
%%Host:主机IP
%%Port:端口
init() ->
    process_flag(trap_exit, true),
    Client = #client{
        player_pid = undefined,
        player_id = 0,
        login = 0,
        login_ip = undefined,
        account_id = undefined,
        account_name = undefined,
        account_type = undefined,
        timeout = 0
    },
    receive
        {go, Socket} ->
            Ip = misc:get_ip(Socket),
            %% 验证IP是否封禁
            %io:format("===ip come=====~p~n", [Ip]),
            {IPstatus, EndTime} = lib_account:get_ip_status(Ip),
            case IPstatus of
                ban ->
                    do_send_pack(Socket, 10005, {s2c_server_close, EndTime}, 0),
                    login_lost(Socket, Client, 0, {login_err, ban_ip});
                unban ->
                    get_socket_data(Socket, Client#client{login_ip = Ip})
            end;
        _ ->
            skip
    end.

%%接收来自客户端的数据 
%%Socket：socket id
%%Client: client记录
get_socket_data(Socket, Client) ->
    Ref = async_recv(Socket, 6, ?HEART_TIMEOUT),
    receive
    %%数据处理
        {inet_async, Socket, Ref, {ok, <<Len:16, Cmd:32>>}} ->     %%消息头处理
            %%io:format("get_socket_data====~p,~p~n", [Len,Cmd]),
            P = tool:to_list(<<Len:16, Cmd:32>>),
            P1 = string:left(P, 4),
            if (P1 == "GET " orelse P1 == "POST") ->   %% http请求
                P2 = string:right(P, length(P) - 4),
                misc_admin:treat_http_request_self(Socket, P2, P1),
                catch erlang:port_close(Socket);
                true -> %%处理其他请求
                    login_parse_packet(Socket, Client, Cmd, Len - 4)
            end;
    %%超时处理
        {inet_async, Socket, Ref, {error, timeout}} ->
            %%io:format("get_socket_data inet_async====~p~n", [Ref]),
            case Client#client.timeout >= ?HEART_TIMEOUT_TIME of
                true ->
                    login_lost(Socket, Client, 11, {error, timeout});
                false ->
                    get_socket_data(Socket, Client#client{timeout = Client#client.timeout + 1})
            end;
    %%用户断开连接或出错
        Other ->
            %%io:format("get_socket_data Other====~p~n", [Other]),
            login_lost(Socket, Client, 12, Other)
    end.

%%接收来自客户端的数据 - 先处理登陆
%%Socket：socket id
%%Client: client记录
login_parse_packet(Socket, Client, Cmd, Len) ->
    BodyLen = Len,
    case BodyLen > 0 of
        true ->
            Ref1 = async_recv(Socket, BodyLen, ?TCP_TIMEOUT),
            receive
                {inet_async, Socket, Ref1, {ok, <<Seq:32, Binary/binary>>}} ->   %%消息内容处理
                    case routing(Client, Cmd, Binary) of
                        %%登陆
                        {ok, Data} ->
                            account_login(Socket, Client, Seq, Data);
                        {error, decrypt_error} ->
                            ?WARNING_MSG("login_parse_packet routing error14 Cmd: ~p/reason: ~p/IP: ~p/~n", [Cmd, decrypt_error, misc:get_ip(Socket)]),
                            login_lost(Socket, Client, 8, {error, decrypt_error});
                        Other ->
                            ?WARNING_MSG("login_parse_packet routing error8 cmd: ~p/Binary:~p/reason: ~p/IP: ~p/~n", [Cmd, Binary, Other, misc:get_ip(Socket)]),
                            login_lost(Socket, Client, 8, Other)
                    end;
                Other ->
                    ?WARNING_MSG("login_parse_packet routing error9 cmd: ~p/Binary:~p/reason: ~p/IP: ~p/~n", [Cmd, BodyLen, Other, misc:get_ip(Socket)]),
                    login_lost(Socket, Client, 9, Other)
            end;
        false ->
            case Client#client.login == 1 of
                true ->
                    get_socket_data(Socket, Client);
                false ->
                    ?WARNING_MSG("login_parse_packet routing error10 cmd: ~p/reason: ~p/IP: ~p/~n", [Cmd, invalid_packet, misc:get_ip(Socket)]),
                    login_lost(Socket, Client, 10, {error, invalid_packet})
            end
    end.

%%用户登录逻辑
account_login(Socket, Client, Seq, ClientData) ->
    [Tick, Sign, Version, Agent, AccounId, Accname, Password, Nick, Channel, Device, Did, AgentCode, OpenId, UnionId, SdkUuid] = ClientData,
    Ip = Client#client.login_ip,
    case lib_account:has_player_id([Tick, Sign, Version, Agent, AccounId, unicode:characters_to_binary(Accname), Password, Nick, Channel, Device, Did, Ip]) of
        {ok, PlayerId, IsFirst} ->
            deal_enter0([PlayerId, IsFirst, Seq, Did, AgentCode, OpenId, UnionId, SdkUuid, Version], Socket, Client#client{account_id = AccounId});
        _R ->
            do_send_pack(Socket, 10001, {s2c_account_login, ?FLAG_FAIL, 0, 0}, Seq),
            get_socket_data(Socket, Client)
    end.


do_send_pack(Sock, Cmd, MsgRecord) ->
    do_send_pack(Sock, Cmd, MsgRecord, 0).
do_send_pack(Sock, Cmd, MsgRecord, Seq) ->
    {ok, DataBin} = pt_10:write(Cmd, [Seq, MsgRecord]),
    lib_send:send_one(Sock, DataBin).

%% 发送消息
do_send(Sock, Bin) ->
    case catch erlang:port_command(Sock, Bin, [force]) of
        true ->
            ok;
        false ->
            ok;
        _Reason ->
            ok
    end.

deal_enter0(Data, Socket, Client) ->
    [PlayerId, _IsFirst, Seq, Did, _AgentCode, _OpenId, _UnionId, _SdkUuid, _Version] = Data,
    case lib_account:ban_imei(Did) of
        {ban, _EndTime} ->
            do_send_pack(Socket, 10001, {s2c_account_login, 10001002, 0, PlayerId}, Seq),
            get_socket_data(Socket, Client);
        _ ->
            deal_enter(Data, Socket, Client)
    end.

%%进入游戏逻辑
deal_enter(Data, Socket, Client) ->
    [PlayerId, IsFirst, Seq, Did, AgentCode, OpenId, UnionId, SdkUuid, Version] = Data,
    case lib_account:ban_account(PlayerId) of
        {ban, _EndTime} ->  % 告诉玩家角色ID被禁
            do_send_pack(Socket, 10001, {s2c_account_login, 10001002, 0, PlayerId}, Seq),
            get_socket_data(Socket, Client);
        _ ->
            case mod_login:login(start, [PlayerId, IsFirst, Client#client.account_id, Client#client.login_ip, Did, AgentCode, OpenId, UnionId, SdkUuid, Version], Socket) of
                {ok, Pid} ->
                    Time = util:unixtime(),
                    do_send_pack(Socket, 10001, {s2c_account_login, ?FLAG_SUCC, Time, PlayerId}, Seq),

                    do_parse_packet(Socket, Client#client{player_pid = Pid, player_id = PlayerId, login = 1, seq = Seq});
                {error, _Reason} ->%%告诉玩家进入失败
                    ?ERROR_MSG("===deal_enter error=====~p,~p~n", [_Reason, Data]),
                    do_send_pack(Socket, 10001, {s2c_account_login, ?FLAG_FAIL, 0, PlayerId}, Seq),
                    get_socket_data(Socket, Client)
            end
    end.

%%接收来自客户端的数据 - 登陆后进入游戏逻辑
%%Socket：socket id
%%Client: client记录
do_parse_packet(Socket, Client) ->
    %%io:format("===do_parse_packet===~p~n", [Client]),
    Ref = async_recv(Socket, ?HEADER_LENGTH, ?HEART_TIMEOUT),
    %%io:format("===do_parse_packet===~p~n", [Ref]),
    receive
        {inet_async, Socket, Ref, {ok, <<Len:16, Cmd:32>>}} ->
            %%io:format("===do_parse_packet===~p~n", [[Len, Cmd]]),
            BodyLen = Len - 4,
            RecvData =
                case BodyLen > 0 of
                    true ->
                        Ref1 = async_recv(Socket, BodyLen, ?TCP_TIMEOUT),
                        receive
                            {inet_async, Socket, Ref1, {ok, Binary}} ->
                                {ok, Binary};
                            Other ->
                                {fail, Other}
                        end;
                    false ->
                        {ok, <<>>}
                end,
            case RecvData of
                {ok, <<Seq:32, BinData/binary>>} ->
                    if
                        Client#client.seq + 1 =:= Seq ->
                            case routing(Client, Cmd, BinData) of
                                %%这里是处理游戏逻辑
                                {ok, Data} ->
                                    %%io:format("===do_parse_packet=Cmd:~p==Data:~p~n", [Cmd, [Seq,Data]]),
                                    Client#client.player_pid ! {routing, [Cmd, Seq, Data]},
                                    do_parse_packet(Socket, Client#client{seq = Seq});
                                Other2 ->
                                    ?WARNING_MSG("do_parse_packet routing error13 Cmd: ~p/reason: ~p/IP: ~p/~n", [Cmd, Other2, misc:get_ip(Socket)]),
                                    do_lost(Client, Cmd, Other2, 2)
                            end;
                        true ->
                            do_parse_packet(Socket, Client)
                    end;
                {fail, Other3} ->
                    ?WARNING_MSG("do_parse_packet routing error14 Cmd: ~p/reason: ~p/IP: ~p/~n", [Cmd, Other3, misc:get_ip(Socket)]),
                    do_lost(Client, Cmd, Other3, 3)
            end;
        {inet_reply, _, ok} ->
            do_parse_packet(Socket, Client);
    %%超时处理
        {inet_async, Socket, Ref, {error, timeout}} ->
            %%io:format("===do_parse_packet timeout===~p~n", [Ref]),
            case Client#client.timeout >= ?HEART_TIMEOUT_TIME of
                true ->
                    ?WARNING_MSG("do_parse_packet routing error11 Ref: ~p/reason: ~p/IP: ~p/~n", [Ref, timeout, misc:get_ip(Socket)]),
                    do_lost(Client, 0, {error, timeout}, 4);
                false ->
                    do_parse_packet(Socket, Client#client{timeout = Client#client.timeout + 1})
            end;
    %%用户断开连接或出错
        Other ->
            ErrStack = lists:concat([?MODULE, "====do_parse_packet"]),
            ?INFO_MSG("do_parse_packet routing error12 reason: ~p/IP: ~p/Trace:~p~n", [Other, misc:get_ip(Socket), ErrStack]),
            %%io:format("===do_parse_packet Other===~p~n", [Other]),
            do_lost(Client, 0, Other, 5)
    end.

%%登录断开连接
login_lost(Socket, Client, Location, Reason) ->
    case lists:member(Location, [1, 2, 11, 12]) of
        true ->
            no_log;
        _ ->
            ?WARNING_MSG("login_lost_/location: ~p/client:~p/reason: ~p/~n", [Location, Client, Reason])
    end,
    timer:sleep(100),
    gen_tcp:close(Socket),
    exit({unexpected_message, Reason}).

%%退出游戏
do_lost(Client, Cmd, Reason, Location) ->
    case lists:member(Location, [3, 4, 5]) of
        true ->
            no_log;
        _ ->
            if Cmd /= 10030 ->
                ?WARNING_MSG("do_lost_/cmd: ~p/loc: ~p/client:~p/reason: ~p/~n", [Cmd, Location, Client, Reason]);
                true ->
                    no_log
            end
    end,
    %%?INFO_MSG("do_lost_/cmd: ~p/loc: ~p/client:~p/reason: ~p/~n",[Cmd, Location, Client, Reason]),
    %%io:format("===do_lost==Cmd:~p===Location:~p=~n", [Cmd, Location]),
    mod_login:logout(Client#client.player_pid),
    exit({unexpected_message, Reason}).


%%路由
%%组成如:pt_10:read
routing(_Client, Cmd, Binary) ->
    %%取前面二位区分功能类型 
    if
        Cmd >= 37000 andalso Cmd < 40000 ->
            new_pt:read(Cmd, Binary);
        true ->
            [H1, H2, _, _, _] = integer_to_list(Cmd),
            Module = list_to_atom("pt_" ++ [H1, H2]),
            Module:read(Cmd, Binary)
    end.

%% 接受信息
async_recv(Sock, Length, Timeout) when is_port(Sock) ->
    case prim_inet:async_recv(Sock, Length, Timeout) of
        {error, Reason} ->
            ?WARNING_MSG("async_recv  Length: ~p/reason: ~p/IP~p~n", [Length, Reason, misc:get_ip(Sock)]),
            %%io:format("===async_recv error==~p~n", [Reason]),
            throw({Reason});
        {ok, Res} ->
            %%io:format("===async_recv ok==~p~n", [Res]),
            Res
    end.

test() ->
    case gen_tcp:connect("192.168.0.104", 10001, [binary, {packet, 0}, {active, false}, {reuseaddr, true}, {nodelay, false}, {delay_send, true}, {send_timeout, 5000}, {keepalive, true}, {exit_on_close, true}], 10000) of
        {ok, Socket} ->
            timer:sleep(3000),
            Res = gen_tcp:send(Socket, <<4:16, 32:32>>),
            io:format("test =====~p~n", [Res]),
            gen_tcp:send(Socket, <<4:16, 32:32>>),
            timer:sleep(3000),
            gen_tcp:send(Socket, <<4:16, 32:32>>),
            io:format("test =====~p~n", [close]),
            gen_tcp:close(Socket);
        _ ->
            ok
    end.
