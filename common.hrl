%%%------------------------------------------------
%%% File    : common.hrl
%%% Author  : csj
%%% Created : 2010-09-15
%%% Description: 公共定义
%%%------------------------------------------------
-ifndef(COMMON_HRL).
-define(COMMON_HRL, 0).

-define(ALL_SERVER_PLAYERS, 100000).
%% 公共协议处理ret_code
-define(FLAG_SUCC, 0).  %% 成功
-define(FLAG_FAIL, 1).  %% 非法错误
-define(FALG_OFFLINE,2).%% 断线

%% 是否
-define(YES,    0).        %% 是
-define(NO,     1).        %% 否

%%常用宏定
-define(TRUE,   true).
-define(FALSE,  false).
-define(IGNORE, ignore).
-define(SKIP,   skip).
-define(OK,     ok).
-define(UNDEFINED,undefined).
-define(NORMAL, normal).
-define(STOP,   stop).
-define(KILL,   kill).
-define(NOREPLY,noreply).
-define(REPLY,  reply).
-define(YES_0,  0).
-define(NO_1,   1).
-define(NULL,   ?UNDEFINED).
-define(FAIL,   xmen_fail).
-define(ERR,    error).
-define(NONE,   xmen_none).
-define(OK(Data), {?OK, Data}).
-define(APPLY(M, F, A), {apply, M, F, A}).

%% IF
-define(IF(C, T, F), (case (C) of true -> (T); false -> (F) end)).
-define(IF(C, T), (case C of true -> T; _ -> ok end)).

%% CASE
-define(CASE(A, B, C), (case A of B -> C; _ -> ok end)).
-define(CASE_NOT(A, B, C), (case A of B -> ok; _ -> C end)).

%% 异步执行代码
-define(ASYNC_EXEC(Code), spawn(fun() -> Code end)).

%% 资源定义
-define(NONE_RESURCE, 0).           	%% 无资源
-define(RESURCE_COIN, 1).           	%% 金币资源
-define(RESURCE_BACKPACK, 2).       	%% 背包资源  

%% 子游戏定义
-define(GAME_HUNDRED_DOUNIU, 1).    	%% 百人牛牛  
-define(GAME_FOWLSBEASTS, 2).       	%% 飞禽走兽（机器人坐庄）
-define(GAME_FOWLSBEASTS_PLAYER, 3). 	%% 飞禽走兽（真实玩家坐庄）
-define(GAME_POKE, 4).    				%% 牌局 
-define(GAME_REDBLACK, 5).          	%% 红黑大战
-define(GAME_ZHAJINHUA, 6).          	%% 炸金花
-define(GAME_SUOHA, 7).          		%% 梭哈
-define(GAME_NIU2, 8).        			%% 二人牛牛
-define(GAME_HUOPIN_NIUNIU, 9).			%% 火拼牛牛
-define(GAME_BY, 10).       			%% 捕鱼
-define(GAME_LONGHUDOU, 11).            %% 龙虎斗
-define(GAME_NINEHALF, 12).            %% 9.5

%% 虚拟物品ID
%% 游戏中流通的货币
-define(MONEY_T_COIN, 100010001).        %% 金币ID
-define(MONEY_T_GOLD, 100010002).        %% 钻石ID
-define(MONEY_T_RED_BEAN, 100010003).    %% 红豆ID
-define(RMB_TO_COIN, 10000).             %% RMB兑换金币系数

%% VIP会员礼包初始购买次数
-define(VIP_GIFT_BUY_NUM, 1).

%%数据库模块选择 (db_mysql 或 db_mongo)
-define(DB_MODULE,       db_mysql).            
%%数据库模块(日志数据库)
-define(DB_LOG_MODULE,   db_mysql_admin).

-define(DB_SERVER,       mysql_dispatcher).            
%%数据库模块(日志数据库)
-define(DB_SERVER_ADMIN, mysql_admin_dispatcher).
%%mongo主数据库链接池
-define(MASTER_POOLID,   master_mongo).
%%mongo从数据库链接池
-define(SLAVE_POOLID,    slave_mongo).
%%Mysql数据库连接 
-define(DB_POOL,         mysql_conn). 

%%消息头长度
-define(HEADER_LENGTH, 6).               %%消息头长度 2Byte 长度 + 4Byte 消息编号
%% 心跳包时间间隔
-define(HEART_TIMEOUT, 60*60*1000).      %%心跳包超时时间
%% 最大心跳包检测失败次数
-define(HEART_TIMEOUT_TIME, 2).          %%心跳包超时次数
-define(TCP_TIMEOUT, 1000).              % 解析协议超时时间

%%安全校验
-define(TICKET, "SDFSDESF123DFSDF"). 

%%tcp_server监听参数
-define(TCP_OPTIONS, [binary, 
                      {packet, 0}, 
                      {active, false}, 
                      {reuseaddr, true}, 
                      {nodelay, false}, 
					  {delay_send, true}, 
                      {send_timeout, 5000}, 
                      {keepalive, true}, 
                      {exit_on_close, true},
					  {buffer,  16 * 1024}, 
                      {backlog, 30000}]).
-define(RECV_TIMEOUT, 5000).

%%自然对数的底
-define(E, 2.718281828459).

%% ---------------------------------
%% Logging mechanism
%% Print in standard output
%-define(PRINT(Format, Args),
%     io:format(Format ++ "~n", Args)).
-define(PRINT(Format, Args), skip).

%%-define(RELEASE_PRINT,true).
%%-ifdef (RELEASE_PRINT).

-define(TEST_MSG(Format, Args),
    logger:test_msg(?MODULE,?LINE,Format, Args)).
-define(DEBUG(Format, Args),
    logger:debug_msg(?MODULE,?LINE,Format, Args)).
-define(INFO_MSG(Format, Args),
    logger:info_msg(?MODULE,?LINE,Format, Args)).                                                                
-define(WARNING_MSG(Format, Args),
    logger:warning_msg(?MODULE,?LINE,Format, Args)).
-define(ERROR_MSG(Format, Args),
    logger:error_msg(?MODULE,?LINE,Format, Args)).
-define(CRITICAL_MSG(Format, Args),
    logger:critical_msg(?MODULE,?LINE,Format, Args)).


-define(TEST(Format, Args),
    logger:test_msg(?MODULE,?LINE,Format, Args)).
-define(INFO(Format, Args),
    logger:info_msg(?MODULE,?LINE,Format, Args)).                                                                
-define(WARNING(Format, Args),
    logger:warning_msg(?MODULE,?LINE,Format, Args)).
-define(ERROR(Format, Args),
    logger:error_msg(?MODULE,?LINE,Format, Args)).
-define(CRITICAL(Format, Args),
    logger:critical_msg(?MODULE,?LINE,Format, Args)).

%% -else.
%% 
%% -define(TEST_MSG(Format, Args),
%%     io:format(Format, Args)).
%% -define(DEBUG(Format, Args),
%%     io:format(Format, Args)).
%% -define(INFO_MSG(Format, Args),
%%     io:format(Format, Args)).                                                                
%% -define(WARNING_MSG(Format, Args),
%%     io:format(Format, Args)).
%% -define(ERROR_MSG(Format, Args),
%%     io:format(Format, Args)).
%% -define(CRITICAL_MSG(Format, Args),
%%     io:format(Format, Args)).
%% 
%% -endif.


-define(H, logger:error_msg(?MODULE,?LINE,"###### only trace!~n", [])).
-define(H(Arg), logger:error_msg(?MODULE,?LINE,"###### only trace:~w~n", [Arg])).
-define(Print(D),io:format("~n only trace! module=~p,line=~p,data:~n~w~n", [?MODULE,?LINE,D])).
-define(P(D), logger:info_msg(?MODULE,?LINE,"data:~n~w~n", [D])).
-define(Stack, erlang:get_stacktrace()).
-define(PrintStack(R), ?ERROR_MSG("error=~p,~nstack=~p~n", [R, ?Stack])).

-define(PidSend, Player#player.other#player_other.pid_send).
-define(PidSend(Player), Player#player.other#player_other.pid_send).
-define(PID_SEND(Player), Player#player.other#player_other.pid_send).

-define(SdkUid, Player#player.other#player_other.sdk_uuid).
-define(SdkUid(Player), Player#player.other#player_other.sdk_uuid).
-define(SDK_UID(Player), Player#player.other#player_other.sdk_uuid).

-define(PlayerID, Player#player.id).
-define(PlayerID(Player), Player#player.id).
-define(NickName, Player#player.nick).
-define(NickName(Player), Player#player.nick).
-define(AcctID, Player#player.account_id).
-define(AcctID(Player), Player#player.account_id).
-define(SERVER_ID, config:get_server_num()).

-define(record_to_tuplelist(Rec, Ref), lists:zip(record_info(fields, Rec),tl(tuple_to_list(Ref)))).


%% 服务器类型：1 网关,2 中心,3 游戏服,4 充值服 5AI 6Agent
-define(SERV_TYPE_GATEWAY,1).
-define(SERV_TYPE_CENTER, 2).
-define(SERV_TYPE_SERVER, 3).
-define(SERV_TYPE_WEB,    4).
-define(SERV_TYPE_AI,     5).
-define(SERV_TYPE_AGENT,  6).

%% 服务器状态 1-新开；2-流畅；3-火爆；4-维护；5-未开放
-define(SERV_STATE_1, 1).
-define(SERV_STATE_2, 2).
-define(SERV_STATE_3, 3).
-define(SERV_STATE_4, 4).
-define(SERV_STATE_5, 5).

-define(MOD_PLAYER_APPLY_CALL(PlayerPid, Mod, Fun, Args),
    gen_server:call(PlayerPid, {apply_call, Mod, Fun, Args})).

-define(MOD_PLAYER_APPLY_CAST(PlayerPid,Mod,Fun,Args),
    gen_server:cast(PlayerPid, {apply_cast, Mod, Fun, Args})).


-define(CATCH_DO(B),
        try (B)
        catch
          _THROW:ErrMask ->
            ?ERROR_MSG("StackTrace:~p",[erlang:get_stacktrace()]),
            {error,ErrMask}
        end).

-define(CATCH_OF_DO(B), 
        try (B) of
            Result ->Result
        catch
          _THROW:ErrMask ->
            ?ERROR_MSG("StackTrace:~p==_THROW:~p==ErrMask:~p",[erlang:get_stacktrace(), _THROW, ErrMask]),
            {error,ErrMask}
        end).

%%worker
-define(ADD_SUP_CHILD_PID_ID(S,M,F,A,ID),supervisor:start_child(S,{ID,{M,F,A},transient, 1000, worker, [M]})).
-define(ADD_SUP_CHILD_PID(S,M,F,A),?ADD_SUP_CHILD_PID_ID(S,M,F,A,erlang:make_ref())).

%%for
-define(SUP_ID(M,ID),cast_util:to_atom(lists:concat([M,"_",ID]))).
-define(ADD_SUP_CHILD_FOR(S,M,F,A,Num),
    lists:foreach(
        fun(ID)->
            MID = ?SUP_ID(M,ID),
            ?ADD_SUP_CHILD_PID_ID(S,M,F,A,MID)
        end,lists:seq(1,Num))).

%%for pool
%%并且根据池名字定义进程名字
-define(ADD_SUP_CHILD_FOR_POOL(P,S,M,F,A,Num),
    lists:foreach(
        fun(ID)->
            MID = MID = ?SUP_ID(P,ID),
            {ok,PID}=?ADD_SUP_CHILD_PID_ID(S,M,F,A,MID),
            erlang:register(MID,PID)
        end,lists:seq(1,Num))).

%%sup
-define(ADD_SUP_CHILD_SUP(S,M,F,A),supervisor:start_child(S,{M,{M,F,A},permanent, infinity, supervisor, [M]})).

%%apply
-define(DO_APPLY(M,F,A),case erlang:apply(M,F,A) of {'EXIT',Err}->?ERROR("Do Apply Error:~p",[Err]),?ERR;Ret000->Ret000 end).
-define(DO_APPLY(F,A),case erlang:apply(F,A) of {'EXIT',Err}->?ERROR("Do Apply Error:~p",[Err]),?ERR;Ret000->Ret000 end).

%%ets常用宏
-define(ETS_PUBLIC_OPTS(TYPE,POS),[public,TYPE,named_table,{keypos,POS},{write_concurrency, true},{read_concurrency, true}]).
-define(NEW_ETS(NAME,TYPE,POS),ets:new(NAME,?ETS_PUBLIC_OPTS(TYPE,POS))).
-define(NEW_ETS_SAFE(NAME,TYPE,POS1),case ets:info(NAME, size) of ?UNDEFINED -> ?NEW_ETS(NAME,TYPE,POS1);_ ->ok end).

%% log event manager name
-define(LOGMODULE, logger_mgr).
-define(GAME_SUP,  game_server_sup).

%% 性别
-define(SEX_ANY,    0).             % 男女通用
-define(SEX_MALE,   1).             % 男
-define(SEX_FEMALE, 2).             % 女

%%打开发送消息客户端进程数量 
-define(SEND_MSG,   1).


%% 时间秒数常量
-define(DIFF_SECONDS_1970_1900, 2208988800).
-define(DIFF_SECONDS_0000_1900, 62167219200).
-define(ONE_DAY_SECONDS,        86400).                     %%一天的时间（秒）
-define(ONE_DAY_MILLISECONDS,   86400000).                  %%一天时间（毫秒）

-define(ONE_DAY_MSECONDS, (24 * 60 * 60 * 1000)).           % 一天的毫秒数
-define(ONE_HOUR_SECONDS, (60 * 60)).                       % 一小时的秒数
-define(ONE_HOUR_MSECONDS, (60 * 60 * 1000)).               % 一小时的毫秒数
-define(ONE_MINUTE_SECONDS, 60).                            % 一分钟的秒数
-define(ONE_MINUTE_MSECONDS, (60 * 1000)).                  % 一分钟的毫秒数
-define(START_NOW, {-1, 0, 0}).                             %% {-1, 0, 0}:表示从当前时间开始 
-define(START_TOMORROW, {-2, 0, 0}).                        %% {-2, 0, 0}:表示从每日零点开始


-define(DEFAULT_NAME, "匿名") .    
%%ETS
-define(ETS_SERVER,             ets_server).
-define(ETS_SERVER_GAME_ONLINE, ets_server_game_online).
-define(ETS_SYSTEM_INFO,        ets_system_info).                               %% 系统配置信息
-define(ETS_MONITOR_PID,        ets_monitor_pid).                               %% 记录监控的PID
-define(ETS_STAT_SOCKET,        ets_stat_socket).                               %% Socket送出数据统计(协议号，次数)
-define(ETS_STAT_DB,            ets_stat_db).                                   %% 数据库访问统计(表名，操作，次数)
-define(ETS_SYS_ANNONUCE,       sys_announce) .
-define(ETS_SERVER_GAME_CONFIG, ets_server_game_config).                        %% 斗地主房间人数干扰系数基础配置
-define(ETS_SMELT_GOODS,        ets_smelt_goods).                               %% 可熔炼的物品列表
-define(ETS_GOODS_CONTROL,      ets_goods_control).                             %% 道具控制表
-define(ETS_PLAYER_GRAND_PRIX,  ets_player_grand_prix).                         %% 玩家大奖赛信息
-define(ETS_SUBGAME_ONLINE,     ets_subgame_online).                            %% 小游戏在线
-define(ETS_ONLINE,             ets_online).                                    %% 本节点在线玩家
-define(ETS_BLACKLIST,          ets_blacklist).                                 %% 黑名单记录表
-define(ETS_GOODS_ONLINE,       ets_goods_online).                              %% 在线物品表
-define(ETS_RELATION,           ets_relation).                                  %% 关系ETS表名
-define(ETS_OFFLINE_MSG,        ets_offline_msg).						                    %% 离线私聊信息
-define(ETS_RELATION_AGENT,     ets_relation_agent).                            %% 玩家关系代理进程ets
-define(ETS_TEMP_SHOP,          temp_shop).							                        %% 商城模版表
-define(ETS_RANK_TOTAL,         ets_rank_total).                                %% 排行榜
-define(ETS_SERVER_DATA,        temp_server_data).						                  %% 服务器全局数据表
-define(ETS_CROSS_DATA,         cross_data).                                    %% 跨服相关数据
-define(PLAYER_COIN_MERCHANT,   player_coin_merchant).                          %% 银商DB
-define(ETS_ROOM_GAME_INFO,     ets_room_game_info).                            %% 本节比赛场房间报名信息
-define(ETS_ASYNC_EVENTS,       player_async_event).                            %% 玩家异步事件表
-define(ETS_ROBOT_PLAYER,       ets_robot_player).                              %% 系统机器人
-define(ETS_CHAT_MESSAGE,       ets_chat_message).                              %% 系统公告


%% 返回结果：
-define(RESULT_OK,   1).            %% 成功
-define(RESULT_FAIL, 0).            %% 失败
-define(DELAY_CALL, 5000).


% 32位有符号数的最大值
-define(MAX_S32, 2147483647).  
% 32位有符号数的最大值
-define(MAX_S64, 9999999999999999999).  

% 16位有符号数的最大值
-define(MAX_S16, 32767).

% 8位有符号数的最大值
-define(MAX_S8, 127).

% 8位无符号数的最大值
-define(MAX_U8, 255).

%%离线信息
-define(ETS_OFFLINE_INFO, offline_info).


%% ===================系统ID=========================
-define(UNLIMITED_SYSTEM_STATE, 0).    %% 当前不受限制
-define(LOTTERY_SYSTEM, 17).           %% 聚宝阁系统 
-define(FOWLSBEASTS_SYSTEM, 21).       %% 飞禽走兽系统
-define(HUNDREDNIUNIU_SYSTEM, 22).     %% 百人牛牛系统
-define(DOUDIZHU_SYSTEM, 16).          %% 斗地主系统
-define(TRADE_SYSTEM, 18).             %% 交易行系统
-define(VIP_PAY_SYSTEM, 31).           %% VIP充值系统
-define(RED_BLACK_SYSTEM, 30).         %% 红黑大战系统
-define(BANK_SYSTEM, 36).              %% 保险箱
-define(ZHAJINHUA_SYSTEM, 40).         %% 炸金花
-define(LONGHUDOU_SYSTEM, 42).         %% 龙虎斗

-record(subgame_info, {
    game_id=0,                            %% 子游戏ID
    game_type=0,                          %% 子游戏类型（对应各种房间等）
    table_id=0,
    node,                               %% 节点名字
    pname,                              %% 进程名字
    timestamp,                          %% 进入时间戳
    is_exit = false                     %% 是否退出
    }).


-record(zhajinhua_table_attr, {
    server_id,
    domain_id,
    table_id,
    table_pid
    }).

-record(by_table_attr, {
    room_id,
    room_type,
    timeout = 0
    }).

-define(GAME_ONLIN, ets_game_online).
-record(game_online, {
    game_id=0,
    play_num=0 
    }).


-define(GAME_START_PARTYS, 10).             %% 新手村牌局次数
-define(HANDLE_PAY_ORDER, 1).               %% 已处理充值订单
-define(UNHANDLE_PAY_ORDER, 0).             %% 未处理充值订单
-define(REPEAT_PRDER, 9).                  %% 重复订单

-define(NORMAL_CHANGE, 0).                  %% 玩家数据正常变更
-define(BAN_ACCID, 1).                      %% 封号
-define(UNBAN_ACCID, 2).                    %% 解封

-endif.
