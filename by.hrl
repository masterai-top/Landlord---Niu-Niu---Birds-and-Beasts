-ifndef(BY_HRL_).
-define(BY_HRL_, true).

-define(DEFAULT_SEQ, 0).
-define(ERR_SYSTEM, 99). 

%% 捕鱼ets
-record(ets_by, {
        id = 1,
        last_day_win_rank_list = [],         %% 昨日盈利榜
        last_day_win_coin = 0,               %% 昨日盈利榜派发金币
        last_week_win_rank_list = [],        %% 上周盈利榜
        last_week_win_coin = 0,              %% 上周盈利榜派发金币
        last_day_rich_rank_list = [],        %% 昨日富豪榜
        last_day_rich_coin = 0,              %% 昨日富豪榜派发金币
        supreme_win_rank_list = {0, []}      %% 至尊盈利榜
    }).

% %% 捕鱼房间ets
% -record(ets_by_room, {
%         room_id,                          %% 房间Id
%         rich_rank_list = [],              %% 富豪榜
%         lucky_rank_list = [],             %% 幸运榜
%         seat_yazhu_list = [],             %% 座位押注列表
%         area_yazhu_list = [],             %% 区域押注列表
%         pot_coin_value = 0,               %% 奖池值
%         pot_ret_hislist = []              %% 奖池开奖记录[#redblack_pot_ret{}..]
%     }).


% %% 玩家捕鱼ets
% -record(player_by, {
%         player_id,                        %% 玩家Id
%         recharge_rmb = 0,                 %% 累计充值
%         cannon_his_list =[],              %% 炮台使用记录
%         cannon_id = 0,                    %% 当前炮台Id
%         day_win_coin = 0,                 %% 今日已赢金币
%         week_win_coin = 0,                %% 当周已赢金币
%         total_win_coin = 0,               %% 累计赢取金币
%         day_yazhu_coin = 0,               %% 今日已押金币
%         week_yazhu_coin = 0,              %% 本周已押金币
%         total_yazhu_coin = 0,             %% 累计押注金币
%         adjust_odds = 0,                  %% 调节赔率
%         adjust_internal_odds = 0,         %% 每次调节的赔率幅度
%         adjust_internal = 0,              %% 每次调节频率
%         adjust_left_times = 0,            %% 调节剩余次数
%         player_time_min = 0,              %% 调控下限
%         player_time_max = 0,              %% 调控上限
%         next_refresh_day_time = 0,        %% 下次刷新日时间
%         next_refresh_week_time = 0        %% 下次刷新周时间
%     }).

%% 捕鱼房间人数ets
-record(ets_by_room_count, {
        room_id,                             %% 房间ID
        room_type = 0,                       %% 房间类型
        count = 0                            %% 房间累计人数
    }).

%% 捕鱼玩家
-record(by_player, {
        player_id,             %% 玩家Id
        account_name = "",     %% 玩家账号
        facelook = 0,          %% 头像
        nick = "",             %% 名称
        vip = 0,               %% vip
        gold = 0,              %% 钻石
        coin = 0,              %% 玩家金币
        pos = 0,               %% 所在位置
        cannon_id = 0,         %% 炮台Id
        total_yazhu_coin = 0,  %% 累计投入
        total_win_coin = 0     %% 累计产出
    }).

%% 鱼
-record(fish, {
        fish_uid,             %% 鱼UId
        fish_id,              %% 鱼Id
        time_stamp,           %% 生成时间戳
        times,                %% 倍数
        path_id               %% 路线Id
    }).

%% 子弹
-record(shoot, {
        shoot_uid,            %% 子弹UId
        fish_uid,             %% 绑定鱼Id
        player_id,            %% 玩家Id
        pos,                  %% 玩家位置
        cannon_id,            %% 炮Id
        time_stamp,           %% 发出时间戳(毫秒)
        pos_x,                %% 坐标X
        pos_y,                %% 坐标Y
        direct,               %% 方向
        angle,                %% 角度
        tan,                  %% 斜率
        pospx,                %% 按下x
        pospy,                %% 按下y
        pos2x,                %% 终点X
        pos2y,                %% 终点Y
        shoot_coin            %% 子弹价值
    }).

%% 捕鱼房间信息
-record(by_room_state, {
        room_id = undefined,               %% 房间Id
        room_type = undefined,             %% 房间类型
        loop_ref = undefined,              
        room_state = undefined,            %% 房间状态
        now_bg_id = 1,                     %% 当前背景Id
        room_state_timestamp = 0,          %% 房间状态结束时间
        timestamp = undefined,             %% 状态终止时间戳
        room_players = [],                 %% 房间玩家列表
        free_pos_list = [],                %% 空闲位置列表
        cold_timestamp = 0,                %% 冰冻结束时间戳
        total_free_times = 0               %% 统计空闲次数
    }).

%% 捕鱼buff
-record(by_buff, {
        id,                               %% buff Id
        timestamp,                        %% 开始时间戳
        effect_time = 0                   %% 持续时间
    }).

%% ETS定义
%%  捕鱼房间数据ets
-define(ETS_BY_ROOM,        ets_by_room).
%%  捕鱼房间人数ets
-define(ETS_BY_ROOM_COUNT,  ets_by_room_count).
%%  玩家捕鱼数据
-define(ETS_PLAYER_BY,      ets_player_by).
%%  捕鱼数据
-define(ETS_BY,             ets_by).



%% 捕鱼
-define(BY, by).

%% 重登超时时间(暂定两分钟)
-define(RELOGIN_TIMEOUT,  60).

%% 释放房间超时时间
-define(ROOM_CANCEL_TIME, 10).

%% 子弹释放时间
-define(SHOOT_TIMEOUT,    60*2).


%% 游戏至少所需金币
-define(MIN_NEED_COIN,    100).

%% 房间最大人数
-define(MAX_ROOM_COUNT,   4).

%% 定时清除
-define(LOOP_CLEAN_TIME, 10000).


%% 技能定义
-define(SKILL_COLD, 1).             %% 冰冻
-define(SKILL_CALL, 2).             %% 召唤
-define(SKILL_LOCK, 3).             %% 锁定
-define(SKILL_LOCK_FISH_1, 4).      %% 锁定鱼(国内)
-define(SKILL_LOCK_FISH_2, 5).      %% 锁定鱼(国外)

%% 最大buff列表
-define(MAX_BUFF_LEN, 20).          %% 最大buff列表长度

%% 全局数据定义
-define(GLOBAL_INPUT, 1).           %% 系统总投入
-define(GLOBAL_OUTPUT, 2).          %% 系统总产出

%% 所有全局数据定义
-define(ALL_GLOBAL, [
    ?GLOBAL_INPUT,
    ?GLOBAL_OUTPUT
    ]).

%% 鱼定义
-define(FISH_NORMAL, 1).                %% 普通鱼
-define(FISH_NETALL, 2).                %% 一网打尽鱼
-define(FISH_ALLSCREEN, 3).             %% 全屏炸弹鱼
-define(FISH_SOMESCREEN, 4).            %% 区域炸弹鱼
-define(FISH_KING, 5).                  %% 鱼王

%% 鱼状态
-define(FISH_STATE_DIE, 0).             %% 普通死亡
-define(FISH_STATE_ALIVE, 1).           %% 存活
-define(FISH_STATE_BOMB_DIE, 2).        %% 炸死


%% 房间定义
-define(ROOM_TASTE, 1).                 %% 体验服


%% 子弹定义
-define(NORMAL_CANNON, 1).              %% 普通炮弹
-define(NOSE_CANNON, 2).                %% 弹头

%% 弹头列表
-define(NOSE_ITEM_LIST, [20010001,20010002,20010003,20010004]).

%% 
-define(CHECK_FREE_LOOP, 10 * 1000).    %% 检测间隔
-define(MAX_FREE_TIMES, 6).             %% 最大空闲次数

%% 弹头ID定义
-define(NOSE_BRONZE,    20010001).       %% 青铜弹头
-define(NOSE_SILVER,    20010002).       %% 白银弹头
-define(NOSE_GOLD,      20010003).       %% 黄金弹头
-define(NOSE_PLATINUM,  20010004).       %% 铂金弹头

%% Error
%% -------------------------------------------
-define(ERR_OK, 0).                     %% 成功
-define(ERROR_80000001, 80000001).      %% "进入房间金币错误"
-define(ERROR_80000002, 80000002).      %% "已经进入游戏房间"
-define(ERROR_80002001, 80002001).      %% "没有足够的炮弹"
-define(ERROR_80002002, 80002002).      %% "非法子弹Id"
-define(ERROR_80003001, 80003001).      %% "更换的炮台不存在"
-define(ERROR_80005001, 80005001).      %% "所需资源不足，无法使用当前技能"

-endif.  %%  
