%%%--------------------------------------
%%% @Module  : game_gateway
%%% @Author  : smyx
%%% @Created : 2013.06.30 
%%% @Description: 游戏网关
%%%--------------------------------------
-module(game_gateway).
-behaviour(gen_server).
-export([start_link/1,server_stop/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3, 
		 chk_max_allow/0, set_max_allow/1, check_uc_sid/2]).

-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").

-record(gatewayinit, {
					  id = 1,
					  init_time = 0,
					  async_time = 0,
					  max_allow = 50000
					 }).


%%开启网关
%%Node:节点
%%Port:端口
start_link(Port) ->
	misc:write_system_info(self(), tcp_listener, {"", Port, now()}),	
	gen_server:start_link(?MODULE, [Port], []).

init([Port]) ->
	misc:write_monitor_pid(self(),?MODULE, {}),
	F = fun(Sock) -> handoff(Sock) end,
	game_gateway_server:stop(Port),
	game_gateway_server:start_raw_server(Port, F, ?ALL_SERVER_PLAYERS),
	Now = unixtime(),
	Async_time = 
		case config:get_gateway_async_time() of
			undefined -> 0;
			Second -> Second
		end,

	ets:new(client_ver, [set, named_table, public, {keypos, #client_ver.tag}]),

	ets:new(gatewayinit, [{keypos, #gatewayinit.id}, named_table, public, set]), 
	ets:insert(gatewayinit,#gatewayinit{id = 1,init_time = Now,async_time = Async_time}),
	
	error_logger:info_msg("~s The center gateway is OK! . ~n", [misc:time_format(now())]),
	%% 	%%开始统计进程
	%% 	{ok, _Pid} = mod_statistics:start(),
	inets:start(),
	{ok, true}.

%%关闭服务器过程禁止刷进游戏
server_stop()-> 
	Now = unixtime(),
	ets:insert(gatewayinit,#gatewayinit{id = 1,init_time = Now,async_time = 100}).

handle_cast(_Rec, Status) ->
	{noreply, Status}.

handle_call(_Rec, _FROM, Status) ->
	{reply, ok, Status}.

handle_info(_Info, Status) ->
	{noreply, Status}.

terminate(normal, Status) ->
	misc:delete_monitor_pid(self()),
	{ok, Status}.

code_change(_OldVsn, Status, _Extra)->
	{ok, Status}.

%%发送要连接的IP和port到客户端，并关闭连接
handoff(Socket) ->
    case recv_packet(Socket) of
        {ok,Cmd,Data,Seq}->
        hand_cmd(Cmd,Data,Seq,Socket),
        handoff(Socket);
        _->
        close
    end.
        
%%发送要连接的IP和port到客户端，并关闭连接
hand_cmd(10000,[Tick, Sign, Agent, Account, Accname, Password, Did, Data],Seq,Socket) ->
    Now = unixtime(),
    Date= time_util:date_format(),
    [{_,_,InitTime,AsyncTime,_MaxAllow}] = ets:match_object(gatewayinit,#gatewayinit{id =1 ,_='_'}),
    if  Now - AsyncTime > InitTime  ->
            case get_server_info([Tick, Sign, Agent, Account, Accname, Password, Did, Data]) of
                {ok, _Uid, ServerIp, ServerPort} ->
                    pack_and_send(Socket, 10000, {s2c_account_connect,0,Account,ServerPort,ServerIp,Date}, Seq);
                {error, Code} ->
                    ?ERROR_MSG("==== game_gateway get_server_info eroor======:~p~n", [[Code, [Tick, Sign, Agent, Account, Accname, Password, Did, Data]]]),
                    if
                        Code =:= 10007003 -> %% 服务器正在维护中
                            pack_and_send(Socket, 10000, {s2c_account_connect,Code, Account,0,"",Date}, Seq);
                        true ->
                            pack_and_send(Socket, 10000, {s2c_account_connect,1, Account,0,"",Date}, Seq)
                    end
            end,
            gen_tcp:close(Socket);
        true ->
            ?ERROR_MSG("game_gateway 60000 Time error:~p", [[Now, AsyncTime, InitTime]]),
            gen_tcp:close(Socket)

    end;
hand_cmd(10020,[Version,Channel],Seq,Socket) ->
    [{_,_,InitTime,AsyncTime,_MaxAllow}] = ets:match_object(gatewayinit,#gatewayinit{id =1 ,_='_'}),
    Now = unixtime(),
    if Now - AsyncTime > InitTime  ->
            case lib_auth:validate_up_ets(Version, Channel) of
							{ok, Result} ->
								{NewVersion, NewChannel, Title, DlAddress, IsUp, UpdateContent} = Result,
								pack_and_send(Socket, 10020, {s2c_client_version_req, 0, NewVersion, NewChannel, Title, DlAddress, IsUp, UpdateContent}, Seq);
							{error, Reason} ->
								pack_and_send(Socket, 10020, {s2c_client_version_req, 1, "", "", "", "", "", ""}, Seq),
								?ERROR_MSG("game_gateway get update error, reason:~p", [Reason])
						end;
		true ->
				?ERROR_MSG("game_gateway 60000 Time error:~p", [[Now, AsyncTime, InitTime]]),
				gen_tcp:close(Socket)
    end;
hand_cmd(Cmd, _, _, Socket) ->
	?ERROR_MSG("game_gateway no process cmd[~p]",[Cmd]),
	gen_tcp:close(Socket).
      
      
recv_packet(Socket)->
    %% TCP
    case gen_tcp:recv(Socket, ?HEADER_LENGTH) of
        {ok, <<Len:16, Cmd:32>>} ->
        BodyLen = Len - 4,
        case gen_tcp:recv(Socket, BodyLen, 3000) of
             {ok, <<Seq:32, Bin/binary>>} ->
                {ok,Data} = pt_10:read(Cmd, Bin),
                {ok,Cmd,Data,Seq};
             _->
                gen_tcp:close(Socket)
        end;
        %% http
        {ok, Packet} ->
            P  = tool:to_list(Packet),
            P1 = string:left(P, 4),
            if (P1 == "GET " orelse P1 == "POST") ->                   
                   P2 = string:right(P, length(P) - 4),
                   misc_admin:treat_http_request(Socket, P2, P1),
                   gen_tcp:close(Socket);              
               true ->
                   gen_tcp:close(Socket)
            end;
        %% Error
        _Reason ->
            %%?Print(_Reason),
            gen_tcp:close(Socket) 
    end.

pack_and_send(Socket, Cmd, MsgRecord, Seq) ->
	[H1, H2, _, _, _] = integer_to_list(Cmd),
	Module = util:string_to_term("pt_"++[H1,H2]),
	{ok,DataBin} = Module:write(Cmd,  [Seq, MsgRecord]),
	gen_tcp:send(Socket, DataBin).


%% 是否创建角色
is_create(Accname) ->
	case db_agent:is_create(Accname) of
		[] ->
			0;
		_R ->
			1
	end.

%%查询服务器当前最大人数设置
chk_max_allow() ->
	[{_,_,_InitTime,_AsyncTime,MaxAllow}] = ets:match_object(gatewayinit,#gatewayinit{id =1 ,_='_'}),
	MaxAllow.

%%设置服务器当前最大人数设置
set_max_allow(Num)->
	[{_,_,InitTime,AsyncTime,_MaxAllow}] = ets:match_object(gatewayinit,#gatewayinit{id =1 ,_='_'}),
	ets:insert(gatewayinit,#gatewayinit{id = 1,
										init_time = InitTime,
										async_time = AsyncTime,
										max_allow = Num}).

unixtime()->
	{M, S, _} = erlang:now(),
    M * 1000000 + S.

longunixtime() ->
    {M, S, Ms} = erlang:now(),
    (M * 1000000000000 + S * 1000000 + Ms) div 1000.


get_server_info([Tick, Sign, Agent, Account, Accname, Password, Did, Data]) ->
	case check_accid_sign([Tick, Sign, Agent, Account, Accname, Password, Did, Data]) of
		true ->
			case mod_disperse:get_login_server([Agent, Account, Accname, Password, Did]) of
                {ok, Uid, ServerIp, ServerPort} -> 
					{ok, Uid, ServerIp, ServerPort};				
			    {error, RetCode} ->
					{error, RetCode}
			end;
		_Error -> %% 平台数据验证不通
			{error, 1}
	end.

check_accid_sign([Tick, Sign, Agent, Account, Accname, Password, Did, Data]) ->
	lib_auth:check_accid_sign([Tick, Sign, Agent, Account, Accname, Password, Did, Data]).


%% 检查sid(Uc平台)
check_uc_sid(UcSid, Tiket) ->
	{_, GameId} = data_config:get_platform_gameid(Tiket),
	{_, ApiKey} = data_config:get_platform_key(Tiket),
	{_, Url} = data_config:get_login_url(Tiket),
%% 	Id = unixtime(),
	Id = longunixtime(),
	Sign = util:md5(lists:concat(["sid=", UcSid, ApiKey])),
	
	L = [{"id", Id}, {"data", [{"sid", UcSid}]}, {"game", [{"gameId", GameId}]}, {"sign", Sign}],
	Json = http_util2:convert_json(L),
	Request = {Url, [], "application/json", Json},
	HTTPOptions = [],
	Options = [],
	%% 	io:format("~n==httpc:request === ~p~n", [Request]),
	case httpc:request(post, Request, HTTPOptions, Options) of
		{ok, {_Status, _Headers, Raw}} ->
			%% 			io:format("~n==httpc:request === ~p~n", [Raw]),
			case rfc4627:decode(Raw) of
				{ok, RequestObject, _}  ->
					case rfc4627:get_field(RequestObject, "state") of
						{ok, State} ->   %% 成功
							case rfc4627:get_field(State, "code", null) of 
								1 ->
									case rfc4627:get_field(RequestObject, "id") of
										{ok, Rid} ->
											ReturnId = Rid;
										_Er ->
											ReturnId = 0
									end,
									
									if
										ReturnId =/= Id ->
											?ERROR_MSG("pp_account check_uc_sid returni_d Error:~p", [[Id, ReturnId]]),
											{10, [], []};
										true ->										
											case rfc4627:get_field(RequestObject, "data") of
												{ok, Data} ->
													AccountId = rfc4627:get_field(Data, "accountId", []),
													NickName = rfc4627:get_field(Data, "nickName", []),
													{1, AccountId, NickName};
												Error ->
													%% 											io:format("~n==Error1 === ~p~n", [Error]),
													?ERROR_MSG("pp_account check_uc_sid get_field data Error:~p", [Error]),
													false
											end
									end;
								10 ->  %% 请求参数错误
									{10, [], []};
								11 ->  %% 用户未登录
									{11, [], []}
							end;
						Error ->
							?ERROR_MSG("pp_account check_uc_sid get_field state Error:~p", [Error]),
							false
					end;
				Error ->
					?ERROR_MSG("pp_account check_uc_sid  decode error:~p", [Error]),
					false
			end;
		Error ->
			?ERROR_MSG("pp_account check_uc_sid  httpc:request error:~p", [Error]),
			false
	end.





