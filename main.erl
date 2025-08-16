%%%--------------------------------------
%%% @Module  : main
%%% @Author  : smyx
%%% @Created : 2013.07.10 
%%% @Description:  服务器开启  
%%%--------------------------------------
-module(main).
-include("record.hrl").
-include("common.hrl").
-include_lib("stdlib/include/ms_transform.hrl"). 

-export([gateway_start/0, 
         gateway_stop/0, 
         local_gateway_start/0, 
         local_gateway_stop/0, 
		 server_start/0, 
         server_stop/0, 
         server_remove/0, 
         info/0, 
         init_db/1, 
         stop_all_server/1]).
-export([game_web_start/0, 
         game_web_stop/0]).

-define(GATEWAY_APPS,       [sasl, gateway, asn1, public_key, crypto, ssl]).
-define(LOCAL_GATEWAY_APPS, [sasl, local_gateway]).
-define(SERVER_APPS,        [sasl, server,asn1, public_key,crypto,ssl,recon,observer_cli]).
-define(HTTP_WEB_APPS,      [crypto, sasl, game_web, asn1, public_key, ssl]).

%% 启动web服务
game_web_start() ->
	try
		start_applications(?HTTP_WEB_APPS)
	after
		timer:sleep(100)
	end.

%% 停止web服务
game_web_stop() ->
	%%mod_web_service:save_db(),
	%%io:format("mod_web_service save_db, succ~n", []),
	%%timer:sleep(60 * 1000),
	%%stop_applications(?HTTP_WEB_APPS),
	%%halt().
	init:stop().

%%启动网关
gateway_start()->
    try
        start_applications(?GATEWAY_APPS)
    after
        timer:sleep(100)
    end.

%%停止网关
gateway_stop() ->
    stop_applications(?GATEWAY_APPS).

%%启动本地网关
local_gateway_start()->
    try
        start_applications(?LOCAL_GATEWAY_APPS)
    after
        timer:sleep(100)
    end.

%%停止本地网关
local_gateway_stop() ->
    stop_applications(?LOCAL_GATEWAY_APPS).

%%游戏服务器
server_start()->
    try
        start_applications(?SERVER_APPS)
    after
        timer:sleep(100)
    end.

%%停止游戏服务器
server_stop() ->
	%%首先关闭外部接入，然后停止目前的连接，等全部连接正常退出后，再关闭应用
    init:stop().


%%撤下节点
server_remove() ->
	%%首先关闭外部接入，然后停止目前的连接，等全部连接正常退出后，再关闭应用
	catch gen_server:cast(mod_kernel, {set_load, 9999999999}),
    mod_login:kick_all(),
	timer:sleep(30*1000),
    stop_applications(?SERVER_APPS),
    erlang:halt().


%% 停止所有服务
stop_all_server(?SERV_TYPE_WEB) ->
	?ERROR_MSG("==stop_all_server==H:~p", [pay_state]),
	game_web_stop();
stop_all_server(?SERV_TYPE_AI) ->
	?ERROR_MSG("==stop_all_server==H:~p", [ai_state]),
    game_ai:server_stop();
stop_all_server(?SERV_TYPE_AGENT) ->
    ?ERROR_MSG("==stop_all_server==H:~p", [agent_state]),
    game_agent:server_stop();
stop_all_server(?SERV_TYPE_CENTER) ->
	?ERROR_MSG("==stop_all_server==H:~p", [center_state]),
	server_stop();
stop_all_server(?SERV_TYPE_SERVER) ->
	?ERROR_MSG("==stop_all_server==H:~p", [server_state]),
	server_stop();
stop_all_server(_) ->
	ok.



info() ->
    SchedId      = erlang:system_info(scheduler_id),
    SchedNum     = erlang:system_info(schedulers),
    ProcCount    = erlang:system_info(process_count),
    ProcLimit    = erlang:system_info(process_limit),
    ProcMemUsed  = erlang:memory(processes_used),
    ProcMemAlloc = erlang:memory(processes),
    MemTot       = erlang:memory(total),
    io:format( "abormal termination:
               ~n   Scheduler id:                         ~p
               ~n   Num scheduler:                        ~p
               ~n   Process count:                        ~p
               ~n   Process limit:                        ~p
               ~n   Memory used by erlang processes:      ~p
               ~n   Memory allocated by erlang processes: ~p
               ~n   The total amount of memory allocated: ~p
               ~n",
              [SchedId, SchedNum, ProcCount, ProcLimit,
               ProcMemUsed, ProcMemAlloc, MemTot]),
      ok.

%%############辅助调用函数##############
manage_applications(Iterate, Do, Undo, SkipError, ErrorTag, Apps) ->
    Iterate(fun (App, Acc) ->
                    case Do(App) of
                        ok -> [App | Acc];%合拢
                        {error, {SkipError, _}} -> Acc;
                        {error, Reason} ->
                            lists:foreach(Undo, Acc),
                            throw({error, {ErrorTag, App, Reason}})
                    end
            end, [], Apps),
    ok.

start_applications(Apps) ->
    manage_applications(fun lists:foldl/3,
                        fun application:start/1,
                        fun application:stop/1,
                        already_started,
                        cannot_start_application,
                        Apps).

stop_applications(Apps) ->
    manage_applications(fun lists:foldr/3,
                        fun application:stop/1,
                        fun application:start/1,
                        not_started,
                        cannot_stop_application,
                        Apps).
	
%%############数据库初始化##############
%% 数据库连接初始化
init_db(App) ->
    init_mysql(App),
	init_mysql_admin(App),%%初始化日志数据库
    auto_id:set_auto_increment(App),
	ok.

%% mysql数据库连接初始化
%% init_mysql(App) ->
%% 	[Host, Port, User, Password, DB, Encode] = config:get_mysql_config(App),
%%     mysql:start_link(?DB_POOL, Host, Port, User, Password, DB,  fun(_, _, _, _) -> ok end, Encode),
%%     mysql:connect(?DB_POOL, Host, Port, User, Password, DB, Encode, true),
%% 	misc:write_system_info({self(), mysql}, mysql, {Host, Port, User, DB, Encode}),
%% 	ok.

init_mysql(App) ->
	[Host, Port, User, Password, DB, Encode,Conns] = config:get_mysql_config(App),
    Test = mysql:start_link(?DB_SERVER, Host, Port, User, Password, DB,  fun(_, _, _, _) -> ok end, Encode),
    MaxConns = 
		case Conns > 1 of
			true ->
				lists:duplicate(Conns, dummy);
			false ->
				[dummy]
		end ,
	 % 启动conn pool
    [begin
		   mysql:connect(?DB_SERVER, Host, Port, User, Password, DB, Encode, true)
    end || _ <- MaxConns],
	misc:write_system_info({self(), mysql}, mysql, {Host, Port, User, DB, Encode}),
	ok.


%% mysql数据库连接初始化（日志数据库）
init_mysql_admin(App) ->
	[Host, Port, User, Password, DB, Encode, Conns] = config:get_mysql_log_config(App),
    mysql:start_link(?DB_SERVER_ADMIN, Host, Port, User, Password, DB,  fun(_, _, _, _) -> ok end, Encode),
	MaxConns = 
		case Conns > 1 of
			true ->
				lists:duplicate(Conns, dummy);
			false ->
				[dummy]
		end ,
	 % 启动conn pool
    [begin
		   mysql:connect(?DB_SERVER_ADMIN, Host, Port, User, Password, DB, Encode, true)
    end || _ <- MaxConns],
%%     mysql:connect(?DB_SERVER_ADMIN, Host, Port, User, Password, DB, Encode, true),
	misc:write_system_info({self(), mysql_admin}, mysql_admin, {Host, Port, User, DB, Encode}),
	ok.


