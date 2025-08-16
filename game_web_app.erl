%% @author Administrator
%% @doc @todo Add description to http_web_app.


-module(game_web_app).
-behaviour(application).
-export([start/2, stop/1, prep_stop/1]).

-include("common.hrl").
-include("record.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
start(normal, []) ->    
    ping_gateway(),
    
	ets:new(?ETS_SYSTEM_INFO, [set, public, named_table]),
    ets:new(?ETS_MONITOR_PID, [set, public, named_table]),
    %%ets:new(?ETS_STAT_SOCKET, [set, public, named_table]),
    %%ets:new(?ETS_STAT_DB, [set, public, named_table]),
	ServerNum = config:get_server_number(game_web),
	MochiConfig = config:get_mochi_web_config(game_web),
	LogPath = config:get_log_path(game_web),
    LogLevel = config:get_log_level(game_web),
	Gateways = config:get_gateway_node(game_web),
    ServerType = config:get_server_type(game_web),
	loglevel:set(tool:to_integer(LogLevel)),    
	io:format("LogPath:~p, loglevel: ~p, ServerType:~p, ServerNum:~p, MochiConfig:~p~n", [LogPath, LogLevel, ServerType, ServerNum, MochiConfig]),
    {ok, SupPid} = game_web_sup:start_link(),
    game_timer:start(game_web_sup),
    game_web:start([MochiConfig, tool:to_integer(ServerType), ServerNum, Gateways, LogPath, tool:to_integer(LogLevel)]),
    {ok, SupPid}.

stop(_State) ->   
    void. 

prep_stop(State) ->
	catch mod_web_service:save_db(),
	io:format("mod_web_service save_db, succ~n", []),
	State.

ping_gateway()->
    case config:get_gateway_node(game_web) of
        undefined -> no_action;
        DataList ->    
			Fun = fun(GatewayNode) ->
						  catch net_adm:ping(GatewayNode)
				  end ,
			lists:foreach(Fun, DataList)
    end.
