%%%-----------------------------------
%%% @Module  : game_server
%%% @Author  : smyx
%%% @Created : 2013.06.30
%%% @Description: 游戏服务器
%%%-----------------------------------
-module(game_server).
-export([start/1]).
-compile([export_all]).
-include("common.hrl").

start([Ip, Port, ServerId, ServerType, Gateways, LogPath, LogLevel]) ->
    %% 开启系统日志
    %% timer:sleep(5000),
    start_sys_log(LogPath, LogLevel),
    ?INFO_MSG("~s start initing server ~p...\n", [misc:time_format(now()), ServerId]),
    misc:write_system_info(self(), tcp_listener, {Ip, Port, now()}),
    inets:start(),
    ok = start_kernel(),                                                        %% 开启核心服务
    ok = start_rand(),                                                          %% 随机种子
    ok = start_client(),                                                        %% 开启客户端连接监控树
    ok = start_mail(),                                                          %% 开启邮件监控树    
    ok = start_tcp(Port),                                                       %% 开启tcp listener监控树
    ok = start_fowlsbeasts_room(),                                              %% 飞禽走兽
    ok = start_disperse([Ip, Port, ServerId, ServerType, Gateways]),            %% 开启服务器路由，连接其他节点
    ok = start_lottery(),                                                       %% 兑将
    ok = start_misc(),                                                          %% 开启杂项监控树
    ok = start_warn(),                                                          %% 预警进程服务
    ok = start_increase(),                                                      %% 游戏自增id
    ok = start_id_global(ServerType),                                           %% 开启全局自增Id

    ok = start_poke_room(),
    ok = start_hundred_douniu_hall(),
    ok = start_zhajinhua_server(),
    ok = start_suoha_server(),
    ok = start_global_water_pool(),

    %% 加载数据进程
    timer:sleep(3000),                                                          %% 让其他已启动的进程db操作完毕
    ok = start_shop(),                                                          %% 开启商城服务
    ok = start_share_shop(),                                                    %% 开启共享商城服务
    ok = start_trade(),                                                         %% 开启商行进程

    ok = start_rank(),                                                          %% 开启排行榜进程
    lib_system_config:init_room_game_info(),

    ok = start_by_global(),                                                     %% 开启捕鱼全局数据进程
    ok = start_by_hall(),                                                       %% 开启捕鱼大厅
    ok = start_redpacket_plaza(),                                               %% 红包广场
    ok = start_game_log(),                                                      %% 系统日志

    ok = start_health_check(),                                                  %% 系统自检
    ok = start_reloader(),                                                      %% 系统热更
    ok = start_async_event(),                                                   %% 异步事件
    ok = start_rdblack_service(),                                               %% 红黑服务
    ok = start_longhudou_service(),                                             %% 龙虎斗
    
    ok = start_robot_service(),    
                                                  %% 机器人服务
%%  		ok = start_ninehalf_serice(),
    ok = start_gm_service(),                                                    %% gm管理服务

    ok = start_pool_control_service(),                                          %% 水池调控服务

    ok = start_chat_service(),                                                  %% 公告服务
    ?INFO_MSG("~s initing end server ~p...\n", [misc:time_format(now()), ServerId]),
    ok.

%%开启核心服务
start_kernel() ->
    {ok, _} = supervisor:start_child(
        game_server_sup,
        {mod_kernel,
            {mod_kernel, start_link, []},
            permanent, 10000, supervisor, [mod_kernel]}),
    ok.

%%随机种子
start_rand() ->
    {ok, _} = supervisor:start_child(
        game_server_sup,
        {mod_rand,
            {mod_rand, start_link, []},
            permanent, 10000, supervisor, [mod_rand]}),
    ok.

%%开启邮件监控树
start_mail() ->
    {ok, _} = supervisor:start_child(
        game_server_sup,
        {mod_mail,
            {mod_mail, start_link, []},
            permanent, 10000, supervisor, [mod_mail]}),
    ok.

start_notice() ->
    {ok, _} = supervisor:start_child(
        game_server_sup,
        {mod_notice,
            {mod_notice, start_link, []},
            permanent, 10000, supervisor, [start_notice]}),
    ok.

%%开启杂项监控树
start_misc() ->
    {ok, _} = supervisor:start_child(
        game_server_sup, {mod_misc,
            {mod_misc, start_link, []},
            permanent, 10000, supervisor, [mod_misc]}),
    ok.

%% 开启预警进程
start_warn() ->
    {ok, _} = supervisor:start_child(
        game_server_sup, {mod_warn,
            {mod_warn, start_link, []},
            permanent, 10000, supervisor, [mod_warn]}),
    ok.

%%
start_world_level() ->
    lib_world_level:startup(),
    ok.

%% 游戏服开启斗地主
start_poke_room() ->
    ServerType = config:get_server_type(),
    case ServerType of
        ?SERV_TYPE_SERVER ->
            lists:foreach(fun(RoomId) ->
                mod_poke_room:get_mod_room_pid(RoomId)
                          end,
                data_room:get_ids());
        _ ->
            ok
    end,
    ok.

start_client() ->
    {ok, _} = supervisor:start_child(
        game_server_sup,
        {game_tcp_client_sup,
            {game_tcp_client_sup, start_link, []},
            transient, infinity, supervisor, [game_tcp_client_sup]}),
    ok.

%%开启tcp listener监控树
start_tcp(Port) ->
    {ok, _} = supervisor:start_child(
        game_server_sup,
        {game_tcp_listener_sup,
            {game_tcp_listener_sup, start_link, [Port]},
            transient, infinity, supervisor, [game_tcp_listener_sup]}),
    ok.

%%开启多线
start_disperse([Ip, Port, ServId, ServerType, Gateways]) ->
    {ok, _} = supervisor:start_child(
        game_server_sup,
        {mod_disperse,
            {mod_disperse, start_link, [Ip, Port, ServId, ServerType, Gateways]},
            permanent, 10000, supervisor, [mod_disperse]}),
    ok.

start_statistics() ->
    {ok, _Pid} = mod_statistics:start(),
    ok.

%% desc: 物品ets表管理
start_goods() ->
    {ok, _} = supervisor:start_child(
        game_server_sup,
        {mod_goods_l,
            {mod_goods_l, start_link, []},
            permanent, 10000, supervisor, [mod_goods_l]}),
    ok.

%% 开启商城进程
start_shop() ->
    case config:get_server_type() =:= ?SERV_TYPE_CENTER of
        false ->
            ok;
        true ->
            ok = game_server_sup:start_child(mod_shop, [])
    end.

%% 开启共享商城进程
start_share_shop() ->
    case config:get_server_type() =:= ?SERV_TYPE_CENTER of
        false ->
            ok;
        true ->
            ok = game_server_sup:start_child(mod_share_shop, [])
    end.

%% 兑奖活动进程
start_lottery() ->
    case config:get_server_type() of
        ?SERV_TYPE_SERVER ->
            mod_lottery:start_mod_lottery_pid(),
            ok;
        _ ->
            ok
    end.

%% 开启商行进程
start_trade() ->
    case trade_util:is_trade_node() of
        false ->
            ok;
        true ->
            %% 当前节点为商行节点的时候，启动商行进程
            {ok, _} = supervisor:start_child(
                game_server_sup,
                {mod_trade_sup,
                    {mod_trade_sup, start_link, []},
                    permanent, infinity, supervisor, [mod_trade_sup]}),
            io:format("start trade process succ ====================================~n", []),
            ok
    end.

%% 飞禽走兽进程
start_fowlsbeasts_room() ->
    case config:get_server_type() of
        ?SERV_TYPE_SERVER ->
            mod_fowlsbeasts_room:start_mod_fowlsbeasts_room_pid(),
            ok;
        _ ->
            ok
    end.

%%好友系统
start_relation() ->
    mod_relation:start_mod_relation(),
    ok.

%%离线消息
start_offline() ->
    _Pid = mod_offline:get_main_offline_pid(),
    ok.

%% 开启mod_increase 监控树
start_increase() ->
    mod_increase:get_mod_increase_pid(),
    ok.

%% 开启mod_id_global
start_id_global(_Type) ->
    {ok, _} = supervisor:start_child(
        game_server_sup,
        {mod_id_global,
            {mod_id_global, start_link, []},
            transient, infinity, worker, [mod_id_global]}),
    ok.


start_sys_log(LogPath, LogLevel) ->
    case filelib:is_dir(LogPath) of
        true -> skip;
        false ->
            file:make_dir(LogPath)
    end,

    {ok, _} = supervisor:start_child(
        game_server_sup,
        {?LOGMODULE,
            {logger_h, start_link, [lists:concat([LogPath, "/log"]), LogLevel]},
            permanent, 5000, worker, dynamic}),
    ok.

%% 开启牛牛大厅进程
start_hundred_douniu_hall() ->
    case config:get_server_type() of
        ?SERV_TYPE_SERVER ->
            %%百人牛牛
            ok = game_server_sup:start_child(mod_hundred_douniu_hall, []),
            %%2人牛牛
            ok = game_server_sup:start_child(mod_niu2_hall, []),
            %%火拼牛牛
            ok = game_server_sup:start_child(mod_huopin_niu_hall, []),
            io:format("start mod_hundred_douniu_hall succ~n", []);
        _ ->
            ok
    end,
    ok.

%% 开启炸金花进程
start_zhajinhua_server() ->
    case config:get_server_type() of
        ?SERV_TYPE_SERVER ->
            {ok, _} = supervisor:start_child(
                game_server_sup,
                {mod_zhajinhua_sup, {mod_zhajinhua_sup, start_link, []},
                    permanent, infinity, supervisor, []}),

            ok = game_server_sup:start_child(mod_zhajinhua_server, []),
            io:format("start mod_zhajinhua_server succ~n", []);
        _ ->
            ok
    end,
    ok.

%% 棱哈
start_suoha_server() ->
    case config:get_server_type() of
        ?SERV_TYPE_SERVER ->
            {ok, _} = supervisor:start_child(
                game_server_sup,
                {mod_suoha_sup, {mod_suoha_sup, start_link, []},
                    permanent, infinity, supervisor, []}),

            ok = game_server_sup:start_child(mod_suoha_server, []),
            io:format("start mod_suoha_server succ~n", []);
        _ ->
            ok
    end,
    ok.

%% 开启全局水池进程
start_global_water_pool() ->
    {ok, _} = supervisor:start_child(
        game_server_sup,
        {mod_global_water_pool,
            {mod_global_water_pool, start_link, []},
            transient, infinity, worker, [mod_global_water_pool]}),
    io:format("start mod_global_water_pool succ~n", []),
    ok.


%% 开启maimaisdk进程
start_maimai_sdk() ->
    case config:get_server_type() =:= ?SERV_TYPE_CENTER of
        false ->
            ok;
        true ->
            BeginTime = util:unixtime(),
            lib_center_maimai_sdk:init_data(),
            EndTime = util:unixtime(),
            io:format("load all user need time: ~p~n", [EndTime - BeginTime]),
            ok = game_server_sup:start_child(mod_maimai_sdk, []),
            io:format("start mod_maimai_sdk succ~n", [])
    end.

%% 开启排行榜进程
start_rank() ->
    case config:get_server_type() of
        ?SERV_TYPE_SERVER ->
            ok = game_server_sup:start_child(mod_game_rank, []),
            io:format("start mod_game_rank succ~n", []);
        ?SERV_TYPE_CENTER ->
            ok = game_server_sup:start_child(mod_center_rank, []),
            io:format("start mod_center_rank succ~n", []);
        _ ->
            skip
    end,
    ok.

%% 开启红黑大战大厅进程
start_redblack_hall() ->
    case config:get_server_type() of
        ?SERV_TYPE_SERVER ->
            ok = game_server_sup:start_child(mod_redblack_hall, []),
            io:format("start mod_redblack_hall succ~n", []);
        _ ->
            ok
    end,
    ok.

%%　红包广场
start_redpacket_plaza() ->
    case config:get_server_type() of
        ?SERV_TYPE_GATEWAY ->
            ok;
        _Other ->
            ok = game_server_sup:start_child(mod_redpackets_plaza, []),
            io:format("start mod_redpackets_plaza succ~n", [])
    end,
    ok.

%% 加载红黑数据
load_redblack_data() ->
    case config:get_server_type() of
        ?SERV_TYPE_SERVER ->
            lib_redblack:load_data(),
            io:format("load_redblack_data succ~n", []);
        _ ->
            ok
    end,
    ok.


start_by_global() ->
    case config:get_server_type() of
        ?SERV_TYPE_CENTER ->
            ok = game_server_sup:start_child(by_global_services, []),
            by_global:start_all_global(game_server_sup),
            io:format("start by_global_services succ~n", []);
        _ ->
            ok
    end,
    ok.

%% 开启捕鱼大厅进程
start_by_hall() ->
    case config:get_server_type() of
        ?SERV_TYPE_SERVER ->
            ok = by_hall:start(game_server_sup),
            io:format("start by_hall succ~n", []);
        _ ->
            ok
    end,
    ok.


%% 开启系统自检　
start_health_check() ->
    case config:get_server_type() of
        ?SERV_TYPE_SERVER ->
            ok = game_server_sup:start_child(mod_health, []),
            io:format("start mod_health succ~n", []);
        _ ->
            ok
    end.


%% 自动加载热更文件　
start_reloader() ->
    ok = game_server_sup:start_child(misc_reloader, []),
    io:format("start misc_reloader succ~n", []),
    ok.


start_game_log() ->
    case config:get_server_type() of
        ?SERV_TYPE_CENTER ->
            log_service:handle_start(game_server_sup),
            io:format("start game_log succ~n", []),
            ok;
        _ -> ok
    end.

%% 开启奖池赛
start_jackpot_race() ->
    F = fun(RoomId) ->
        Id = mod_jackpot_race:get_race_process(RoomId),
        game_server_sup:start_child(Id, mod_jackpot_race, [RoomId])
        end,
    lists:foreach(F, data_jackpot_room:get_ids()),
    ok.


%% 异步事件
start_async_event() ->
    case config:get_server_type() of
        ?SERV_TYPE_CENTER ->
            ok = game_server_sup:start_child(mod_async_event, []),
            io:format("start mod_async_event succ~n", []),
            ok;
        _ -> ok
    end.

start_rdblack_service() ->
    case config:get_server_type() of
        ?SERV_TYPE_SERVER ->
            rdblack_service:handle_start(game_server_sup),
            io:format("start rdblack_service succ~n", []),
            ok;
        _ -> ok
    end.

start_longhudou_service() ->
    case config:get_server_type() of
        ?SERV_TYPE_SERVER ->
            longhudou_service:handle_start(game_server_sup),
            io:format("start longhudou_service succ~n", []),
            ok;
        _ ->
            ok
    end.

start_robot_service()->
    case config:get_server_type() of
        ?SERV_TYPE_CENTER ->
            robot_service:handle_start(game_server_sup),
            io:format("start robot_service succ~n", []),
            ok;
        _ -> ok
    end.

%% 开启9.5进程
start_ninehalf_serice() ->
    case config:get_server_type() of
        ?SERV_TYPE_SERVER ->
            {ok, _} = supervisor:start_child(
                game_server_sup,
                {ninehalf_sup, {ninehalf_sup, start_link, []},
                    permanent, infinity, supervisor, []}),

            ok = game_server_sup:start_child(ninehalf_server, []),
            io:format("start mod_ninehalf_server succ~n", []);
        _ ->
            ok
    end,
    ok.
    
start_gm_service()->
    case config:get_server_type() of
        ?SERV_TYPE_SERVER ->
            Options = get_xmen_config(),
            {ok, _} = supervisor:start_child(
                game_server_sup,
                {gm_web_service,
                    {gm_web_service, start_link, [Options]},
                    transient, infinity, worker, [gm_web_service]}),
            io:format("start gm_web_service succ~n", []),
            ok;
        _ -> ok
    end.

get_xmen_config() ->
    Port = xmen_config:get_liner([mochiweb_config, port]),
    PoolSize = xmen_config:get_liner([mochiweb_config, acceptor_pool_size]),
    Max = xmen_config:get_liner([mochiweb_config, max]),
    [{port, Port},                                      %% web服务器端口
    {name, yxddz_gm_web_service},                       %% 进程名
    {acceptor_pool_size, PoolSize},
    {max, Max}].


start_pool_control_service() ->
    case config:get_server_type() of
        ?SERV_TYPE_SERVER ->
            pool_ctrl_service:handle_start(game_server_sup),
            io:format("start pool_ctrl_service succ~n", []),
            ok;
        _ ->
            ok
    end.

start_chat_service() ->
    case config:get_server_type() of
        ?SERV_TYPE_CENTER ->
            chat_service:handle_start(game_server_sup),
            io:format("start chat_service succ~n", []),
            ok;
        _ -> ok
    end.