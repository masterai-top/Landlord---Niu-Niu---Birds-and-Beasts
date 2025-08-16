-ifndef(AWARD_HRL_).
-define(AWARD_HRL_, true).


%% 玩家奖励数据
-record(player_award, {
        player_id,                  %% 玩家Id
        acc_vip_times = 0,          %% 累计今日VIP抽奖次数
        acc_daily_times = 0,        %% 累计今日每日抽奖次数
        acc_system_times = 0,       %% 累计系统补偿次数 
        acc_login_days = 1,         %% 玩家连续登陆天数
        next_refresh_day,           %% 下次刷新日期 
        tomorrow_times = 0,         %% 明日礼包触发次数
        tomorrow_status = 1,        %% 明日礼包开启状态(0开启，1否)
        tomorrow_award_time = 0     %% 明日礼包领取时间
    }).

%% 明日礼包所需次数
-define(TOMORROW_NEED_TIMES, 3).

%% ETS定义
%%  玩家奖励数据ets
-define(ETS_PLAYER_AWARD, ets_player_award).

%% 最多连续登陆天数
-define(MAX_ACC_LOGIN_DAYS, 7).

%% 协议返回值定义
-define(FLAG_20001001, 20001001). %% "已经发放完所有系统补偿"
-define(FLAG_20001002, 20001002). %% "还没达到系统补偿最低金额"
-define(FLAG_20002001, 20002001). %% "今日每日奖励已经领取"
-define(FLAG_20003001, 20003001). %% "已经领取所有VIP奖励"
-define(FLAG_20003002, 20003002).  %% "金币不足，无法抽奖"

-define(FLAG_20004001, 20004001).  %% "明日礼包还没可以领取"

-endif.  %%  