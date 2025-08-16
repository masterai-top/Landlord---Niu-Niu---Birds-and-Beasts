%%%-----------------------------------
%%% @Module  : game_server_app
%%% @Author  : smyx
%%% @Created : 2013.06.30
%%% @Description: 游戏服务器应用启动
%%%-----------------------------------
-module(game_server_app).
-behaviour(application).
-export([start/2, stop/1,prep_stop/1]).
-include("common.hrl").
-include("record.hrl").
-include("define_ddz_ai.hrl").

start(normal, []) ->    
    ping_gateway(),
    ping_calculate(),
    ets:new(?ETS_SYSTEM_INFO, [set, public, named_table]),
    ets:new(?ETS_MONITOR_PID, [set, public, named_table]),
    ets:new(?ETS_STAT_SOCKET, [set, public, named_table]),
    ets:new(?ETS_STAT_DB, [set, public, named_table]),
    
    [Port, _Acceptor_num, _Max_connections] = config:get_tcp_listener(server),
    [Ip] = config:get_tcp_listener_ip(server),
	LogPath = config:get_log_path(server),
    LogLevel = config:get_log_level(server),
	Gateways = config:get_gateway_node(server),
	ServerNum = config:get_server_num(),
    ServerType = config:get_server_type(),
	loglevel:set(tool:to_integer(LogLevel)),    
	io:format("LogPath:~p, loglevel: ~p~n", [LogPath, LogLevel]),
    {ok, SupPid} = game_server_sup:start_link(),
    game_timer:start(game_server_sup),
    %% 通用配置
    xmen_config:init(),
    game_server:start(
                  [Ip, tool:to_integer(Port), tool:to_integer(ServerNum), tool:to_integer(ServerType), Gateways, LogPath, tool:to_integer(LogLevel)]
                ),
    {ok, SupPid}.

stop(_State) ->   
    void. 


%% prep_stop/1
%% --------------------------------------
prep_stop(State)->
    catch mod_id_global:save_all_id(),
    io:format("mod_id_global save_all_id, succ~n", []),
    ?ERROR_MSG("==server_stop===2==", []),
    catch mod_shop:save_db(),
    ?ERROR_MSG("==server_stop===3==", []),
    io:format("mod_shop save_db, succ~n", []),
    catch mod_disperse:save_system_goods_control(),
    ?ERROR_MSG("==server_stop===4==", []),
    io:format("mod_disperse save_system_goods_control, succ~n", []),
    catch mod_global_water_pool:save_db(),
    ?ERROR_MSG("==server_stop===5==", []),
    io:format("mod_global_water_pool save_db, succ~n", []),
    io:format("~n==================all db save finish====================~n~n", []),
    catch gen_server:cast(mod_kernel, {set_load, 9999999999}),
    ?ERROR_MSG("==server_stop===6==", []),
    catch mod_login:stop_all(),
    ?ERROR_MSG("==server_stop===7==", []),
    catch wait_player(300),
    ?ERROR_MSG("==server_stop===8==", []),
    State.



wait_player(Cnt) when Cnt =< 0 -> ok;
wait_player(Cnt) ->
    UserNum = ets:info(?ETS_ONLINE,size),
    if UserNum =:= 0 -> ok;
       true ->
            timer:sleep(1000),    
            wait_player(Cnt-1)
    end.

%% ping_gateway/0
%% --------------------------------------
ping_gateway()->
    case config:get_gateway_node(server) of
        undefined -> no_action;
        DataList ->    
			Fun = fun(GatewayNode) ->
						  catch net_adm:ping(GatewayNode)
				  end ,
			lists:foreach(Fun, DataList)
    end.



%% ping_calculate/0
%% --------------------------------------
-ifdef(DEF_CAL_NODE).

ping_calculate()->
    case config:get_calculate_node(server) of
        undefined -> no_action;
        DataList ->    
			Fun = fun(CalCulateNode) ->
						  catch net_adm:ping(CalCulateNode)
				  end ,
			lists:foreach(Fun, DataList)
    end.

-else.

ping_calculate()->
	ok.

-endif.



