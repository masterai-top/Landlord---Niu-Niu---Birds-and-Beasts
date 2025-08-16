%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 八月 2017 11:46
%%%-------------------------------------------------------------------
-ifndef(GAME_LOG_HRL_).
-define(GAME_LOG_HRL_, 0).
%% 默认切换文件时间(秒)
-define(DEFAULT_SWITCH_FILE_TIMES, 300).
%% 是否发送日志到第三方（web）
-define(SEND_TO_WEB, false).
-define(WEB_API_URI, "http://127.0.0.1/api/game_log/").
-define(LOG_DATA_SEP, "|"). %% 日志分割符

%% 创建账号
-define(LOG_ACC_CREATE, 'account_reg').

%% 创建角色
-define(LOG_ROLE_CREATE, 'role_reg').

%% 上线日志
-define(LOG_LOGIN, 'account_act').

%% 角色上线日志
-define(LOG_ROLE_LOGIN, 'role_act').

%% 下线日志
-define(LOG_LOGOUT, 'account_act').

%% 在线人数统计
-define(LOG_ONLINE_NUM, 'online_data').

%% 房间进入日志
-define(LOG_ENTER_ROOM, 'enter_room').

%% 金币日志
-define(LOG_COIN, 'coin_change').

%% 钻石日志
-define(LOG_RED_PACKET, 'packet_change').

%% 钻石日志
-define(LOG_GOLD, 'diamond_change').

%% 金币调控日志
-define(LOG_RECOVERY_COIN, 'recovery_coin_log').

%% 机器人金币日志
-define(LOG_REBOT_COIN, 'robot_coin_change').

%% 充值
-define(LOG_RECHARGE, 'recharge').

%% 签到
-define(LOG_SIGN, 'sign').

%% 购买夺宝
-define(LOG_YYDB_BUY_ACTION, 'yydb_buy').

%% 一元夺宝领取奖励
-define(LOG_YYDB_FETCH_REWARD, 'yydb_fetch_reward').

%% 一元夺宝开奖
-define(LOG_YYDB_OPEN_REWARD, 'yydb_open_reward').

%% 红包广场
-define(LOG_RED_PACKETS, 'red_packet').

%% 破产红包
-define(LOG_BANKRUPT, 'role_bankrupt').

%% 神秘商人
-define(LOG_MYSTERY_SHOP_TRIG, 'mystery_shop_trig').

%% 神秘商人购买
-define(LOG_MYSTERY_SHOP_BUY, 'mystery_shop_buy').

%% 交易行
-define(LOG_TRADE, 'log_trade').

%% 用户信息变更
-define(LOG_USER_CHANGE, 'user_change').

%% 道具变更
-define(LOG_PROPS_CHANGE, 'props_change').

%% 系统抽水日志
-define(LOG_CHOUSHUI, 'log_choushui').

%% 奖券日志
-define(LOG_LOTTERY, 'log_lottery').

%% 游戏记录
-define(LOG_MATCH_RECORD, 'match_record').

%% 兑换日志
-define(LOG_EXCHANGE, 'exchange').

%% 捕鱼打鱼日志
-define(LOG_SHOOT_FISH, 'log_shoot_fish').

%% 捕鱼掉落日志
-define(LOG_BY_DROP, 'log_by_drop').

%% 开宝箱日志
-define(LOG_TREASURE_BOX, 'log_treasure_box').

%% 游戏日志
-define(LOG_SUBGAME, 'log_subgame').

%% 兑换码日志
-define(LOG_ACTIVE_CODE, 'log_active_code').

%% 举报玩家日志
-define(LOG_REPORT_PLAYER, 'report_player').

%% 金库日志
-define(LOG_ROLE_COFFERS, 'log_coffers').

%% 绑定手机号
-define(LOG_ROLE_BIND_PHONE, 'bind_phone').

%% 百人牛牛开牌日志
-define(LOG_HUNDRED_DOUNIU_DEALER_CARD, 'log_hundred_douniu_dealer_card').

%% 经验
-define(LOG_ROLE_EXP, 'log_role_exp').

%% 周卡购买
-define(LOG_WEEK_CARD_BUY, 'log_week_card_buy').

%% 周卡领取
-define(LOG_WEEK_CARD_FETCH, 'log_week_card_fetch').

%% 飞禽走兽
-define(LOG_FOWLS_BEASTS, log_fowls_beast).

%% 商店日志
-define(LOG_STORE, 'store').

%% 任务日志
-define(LOG_TASK, 'task').

%% 活动日志
-define(LOG_ACTIVITY, 'activity').

%% 玩家行为日志
-define(LOG_PLAYER_BEHAVIOR, 'player_behavior').

%% 消耗数据日志
-define(LOG_CONSUME, 'consume').


%% 日志列表
-define(LOG_TYPE_LIST, [
    ?LOG_USER_CHANGE,
    ?LOG_PROPS_CHANGE,
    ?LOG_LOGIN,
    ?LOG_ROLE_LOGIN,
    ?LOG_COIN,
    ?LOG_GOLD,
    ?LOG_RED_PACKET,
    ?LOG_RECOVERY_COIN,
%%    ?LOG_GOT_RED_PACKETS,
    %%?LOG_LOTTERY,
    ?LOG_RED_PACKETS,
    ?LOG_EXCHANGE,
    %%?LOG_YYDB_BUY_ACTION, 
    ?LOG_RECHARGE,
    %%?LOG_SHOOT_FISH, 
    ?LOG_ACC_CREATE,
    ?LOG_ROLE_CREATE,
    ?LOG_ONLINE_NUM,
    %%?LOG_ENTER_ROOM, 
    ?LOG_REBOT_COIN,
    ?LOG_SIGN,
    %%?LOG_YYDB_OPEN_REWARD,
    ?LOG_BANKRUPT,
    ?LOG_TREASURE_BOX,
    %%?LOG_SUBGAME, 
    ?LOG_MATCH_RECORD,
    ?LOG_REPORT_PLAYER,
    ?LOG_STORE,
    ?LOG_TASK,
%%    ?LOG_ACTIVITY,
    ?LOG_PLAYER_BEHAVIOR,
    ?LOG_CONSUME
    %%?LOG_YYDB_FETCH_REWARD,
    %%?LOG_ACTIVE_CODE, 
    %%?LOG_ROLE_COFFERS,
    %%?LOG_ROLE_BIND_PHONE, 
    %%?LOG_HUNDRED_DOUNIU_DEALER_CARD,
    %%?LOG_ROLE_EXP,
    %%?LOG_MYSTERY_SHOP_TRIG, 
    %%?LOG_MYSTERY_SHOP_BUY, 
    %%?LOG_WEEK_CARD_BUY,
    %%?LOG_WEEK_CARD_FETCH,
    %%?LOG_CHOUSHUI,
    %%?LOG_FOWLS_BEASTS
]).

-endif.