%%%-----------------------------------
%%% @Module  : game_server
%%% @Author  : smyx
%%% @Created : 2013.06.30
%%% @Description: 游戏服务器
%%%-----------------------------------
-module(game_web).
-export([start/1]).
-compile([export_all]).

-include("common.hrl").

%% -define(INFO_MSG(Str), error_logger:info_msg(Str)).
%% -define(INFO_MSG(Str, Args), error_logger:info_msg(Str, Args)).

start([MochiOption, ServerType, ServerNum, Gateways, LogPath, LogLevel]) ->
	%%timer:sleep(5000),
	%% 开启系统日志
	start_sys_log(LogPath, LogLevel),
	?INFO_MSG("~s start initing http_web server ...\n", [misc:time_format(now())]),
	io:format("~s start initing http_web server ...\n", [misc:time_format(now())]),
    %%misc:write_system_info(self(), tcp_listener, {Ip, Port, now()}),
    inets:start(),
	start_kernel(),
    start_disperse([0, 0, ServerNum, ServerType, Gateways]),    %%开启服务器路由，连接其他节点
    start_rand(),
	start_mochi_web(MochiOption),
    start_reloader(),
	?INFO_MSG("~s initing end http_web server ...\n", [misc:time_format(now())]),
	io:format("~s initing end http_web server ...\n", [misc:time_format(now())]),
    ok. 

%% 开启web服务
start_mochi_web(Options) ->
	{ok, _} = supervisor:start_child(
				game_web_sup, 
				{web_service,
				 {web_service, start_link, [Options]},
				 permanent, 10000, worker, [web_service]}),
%% 	game_web_sup:start_child(web_service, [Options]),
	ok.

%%开启核心服务
start_kernel() ->
    {ok,_} = supervisor:start_child(
               game_web_sup,
               {mod_web_service,
                {mod_web_service, start_link,[]},
                permanent, 10000, supervisor, [mod_web_service]}),
    ok.

%%开启多线
start_disperse([Ip, Port, ServId, ServerType, Gateways]) ->
    {ok,_} = supervisor:start_child(
               game_web_sup,
               {mod_disperse,
                {mod_disperse, start_link,[Ip, Port, ServId, ServerType, Gateways]},
                permanent, 10000, supervisor, [mod_disperse]}),
    ok.

%%随机种子
start_rand() ->
    {ok,_} = supervisor:start_child(
               game_web_sup,
               {mod_rand,
                {mod_rand, start_link,[]},
                permanent, 10000, supervisor, [mod_rand]}),
    ok.

%% 热加载
start_reloader() ->
    {ok,_} = supervisor:start_child(
               game_web_sup,
               {misc_reloader,
               {misc_reloader, start_link,[]},
               permanent, 10000, worker, [misc_reloader]}),
    ok.

%% 系统日志
start_sys_log(LogPath, LogLevel) ->
	case filelib:is_dir(LogPath) of
		true -> skip;
		false ->
			file:make_dir(LogPath)
	end,
    {ok,_} = supervisor:start_child(
               game_web_sup,
               {?LOGMODULE,
                {logger_h, start_link, [lists:concat([LogPath, "/log"]), LogLevel]},
                permanent, 5000, worker, dynamic}),
    ok.
