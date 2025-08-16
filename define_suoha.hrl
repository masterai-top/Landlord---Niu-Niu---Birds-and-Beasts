%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. 五月 2017 14:59
%%%-------------------------------------------------------------------
-author("Administrator").
-ifndef(DEFINE_SUOHA_HRL).
-define(DEFINE_SUOHA_HRL,0).

-define(RETURN_CODE(Code), {error, Code}).
%% 抛出错误码
-define(THROW_CODE(Code),  error({error, Code})).
-define(EXIT_CODE(Code),   {'EXIT', Code}).

-define(ROLE_STATE_PRE,     0).
-define(ROLE_STATE_READY,   1).
-define(ROLE_STATE_PLAY,    2).
-define(ROLE_STATE_GIVE_UP, 3).
-define(ROLE_STATE_LOSE,    4).
-define(ROLE_STATE_ONHOOK,  5).  %% 挂机状态
-define(ROLE_STATE_OFFLINE, 6).  %% 离线状态

%% 退出方式
-define(ROLE_EXIT_1, 1).         %% 正常退出
-define(ROLE_EXIT_2, 2).         %% 异常退出

-define(PLAYER_TYPE_AI,     0).                 %% AI玩家
-define(PLAYER_TYPE_ROLE,   1).                 %% 真实玩家

%% 金幣操作
-define(OPT_COIN_ADD,       0).                 %% 增加金幣
-define(OPT_COIN_REDUCE,    1).                 %% 減少金幣

-define(RM_TYPE_NORMAL,     0).                 %% 普通房间
-define(RM_TYPE_PRIVATE,    1).                 %%　私人房间

-define(TABLE_STATE_PREPARE,0).
-define(TABLE_STATE_READY,  1).
-define(TABLE_STATE_PLAY,   2).
-define(TABLE_STATE_CALC_RESULT, 3).

-define(OPT_TYPE_RANG_PAI, 0).                  %% 让牌
-define(OPT_TYPE_GEN_ZHU,  1).                  %% 跟注
-define(OPT_TYPE_JIA_ZHU,  2).                  %% 加注
-define(OPT_TYPE_GIVE_UP,  3).                  %% 弃牌
-define(OPT_TYPE_SUO_HA,   4).                  %% 梭哈
-define(OPT_TYPE_KAI_PAI,  5).                  %% 开牌
-define(OPT_TYPE_LOOK,     6).                  %% 看牌

%% 游戏各种步骤
-define(STEP_GAME_PREPARE, 1).                  %% 预处理阶段
-define(STEP_GAME_READY,   2).                  %% 准备开始
-define(STEP_GAME_PLAYING, 3).                  %% 游戏中
-define(STEP_GAME_WAIT_DEAL_CARDS, 4).          %% 等待发牌动作
-define(STEP_GAME_END, 5).                      %% 游戏结束
-define(STEP_AFTER_GAME_END, 6).                %% 游戏结束后处理

-define(TIME_GAME_END, 3800).                   %% 游戏结算时间

-define(RETURN_ERR(Code), {error, Code}).
-define(THROW_ERR(Code),  throw({error, Code})).


-define(SUOHA_DEBUG, false).
-define(GAME_SUOHA_TYPE, suoha).
-define(CARD_LIST, [
    81,  82,  83,  84,
    91,  92,  93,  94,
    101, 102, 103, 104,
    111, 112, 113, 114,
    121, 122, 123, 124,
    131, 132, 133, 134,
    141, 142, 143, 144
]).

-define(CARD_NUMBER_PER_PLAYER, 5).

-define(CARD_VAL_LIST, [8, 9, 10, 11, 12, 13, 14]).

-define(ALL, '$SUOHA_ALL').
-define(IMPOSSIBILITY, '$SUOHA_IMPOSSIBILITY').

%% 牌类型定义
-define(GROUP_CARD_TYPE_NONE,           0).
-define(GROUP_CARD_TYPE_DANZHANG,       1).
-define(GROUP_CARD_TYPE_DUIZI_1,        2).
-define(GROUP_CARD_TYPE_DUIZI_2,        3).
-define(GROUP_CARD_TYPE_3_ZHANG,        4).
-define(GROUP_CARD_TYPE_SHUNZI,         5).
-define(GROUP_CARD_TYPE_TONGHUA,        6).
-define(GROUP_CARD_TYPE_HULU,           7).
-define(GROUP_CARD_TYPE_4_ZHANG,        8).
-define(GROUP_CARD_TYPE_TONGHUASHUN,    9).
-define(GROUP_CARD_TYPE_DA_TONGHUASHUN, 10).

-define(GROUP_CARD_LIST, [?GROUP_CARD_TYPE_TONGHUASHUN, 
                          ?GROUP_CARD_TYPE_4_ZHANG, 
                          ?GROUP_CARD_TYPE_HULU, 
                          ?GROUP_CARD_TYPE_TONGHUA,
                          ?GROUP_CARD_TYPE_SHUNZI, 
                          ?GROUP_CARD_TYPE_3_ZHANG, 
                          ?GROUP_CARD_TYPE_DUIZI_2, 
                          ?GROUP_CARD_TYPE_DUIZI_1, 
                          ?GROUP_CARD_TYPE_DANZHANG]).

%% 最终张数
-define(LAST_CARDS_NUM, 5).

%% 最多轮数
-define(MAX_LOOP_NUM,   4).

-define(ETS_ENEMY_CARDSLIST, '$ets_enemy_cardslist').


%% 冤家牌浮动范围
-define(ENEMY_CARDS_RANDOM_OFFSET, 5000).

%% 随机最大次数
-define(MAX_RANDOM_TIMES, 100).

%% ai加入间隔
-define(AI_ADD_TIME_INTERVAL, 10).

-define(RECHARGE_COUNT_DOWN,  25).

%% 头像列表
-define(FACELOOK_LIST, ["10001", "10002", "10003", "10004", "10005", "10006"]).

-define(AI_CHARACTER_WIN,           0).      %% 必赢
-define(AI_CHARACTER_CONSERVATIVE,  1).      %% 保守派
-define(AI_CHARACTER_NORMAL,        2).      %% 普通
-define(AI_CHARACTER_RADICAL,       3).      %% 激进

-define(AI_GAME_TYPE_PLAY_WITH,     0).      %% 0陪玩模式
-define(AI_GAME_TYPE_CONTROL,       1).      %% 1调控模式

-define(AI_OPT_CONFIG_TYPE_POWER,   1).      %% 牌力
-define(AI_OPT_CONFIG_TYPE_WINRATE, 2).      %% 胜率

%% 金币充值比例
-define(RECHARGE_RATE, 10000).

%% 系统调控模式
-define(SYSTEM_CONTROL_TYPE_FREE_WIN, 0).   %% 非R赢钱模式
-define(SYSTEM_CONTROL_TYPE_NONE,     1).   %% 不调控
-define(SYSTEM_CONTROL_TYPE_PAY_WIN,  2).   %% 付费赢钱模式
-define(SYSTEM_CONTROL_TYPE_LOSE,     3).   %% 输钱模式

%% 生成冤家牌最多数量
-define(ENEMY_CARDS_GEN_MAX_NUMBER, 3).

%% ai action消息
-define(AI_ACTION_MSG(RoleID, Request), {ai_action, {RoleID, lib_suoha_pd:get_game_count()}, Request}).
-define(AI_ACTION_MSG(RoleID, GameCount, Request), {ai_action, {RoleID, GameCount}, Request}).
%% 发送给ai消息
-define(AI_CAST_MSG(RoleID, Request), {ai_msg, {RoleID, lib_suoha_pd:get_game_count()}, Request}).
-define(AI_CAST_MSG(RoleID, GameCount, Request), {ai_msg, {RoleID, GameCount}, Request}).

-define(DEBUG_TOUJI,    unicode:characters_to_binary("博大/偷鸡")).
-define(DEBUG_LOOK,     unicode:characters_to_binary("看牌")).
-define(DEBUG_GIVEUP,   unicode:characters_to_binary("弃牌")).
-define(DEBUG_RANGPAI,  unicode:characters_to_binary("让牌")).
-define(DEBUG_GENZHU,   unicode:characters_to_binary("跟注")).
-define(DEBUG_JIAZHU,   unicode:characters_to_binary("加注")).
-define(DEBUG_SUOHA,    unicode:characters_to_binary("梭哈")).
-define(DEBUG_LOOP,     unicode:characters_to_binary("轮")).
-define(DEBUG_CARDS,    unicode:characters_to_binary("牌")).
-define(DEBUG_POWER,    unicode:characters_to_binary("牌力")).
-define(DEBUG_WINRATE,  unicode:characters_to_binary("胜率")).
-define(DEBUG_OPTTIME,  unicode:characters_to_binary("操作时间")).
-define(DEBUG_ENEMY_CARDS, unicode:characters_to_binary("冤家牌")).
-define(DEBUG_AIWIN_CARDS, unicode:characters_to_binary("AI必赢牌")).
-define(DEBUG_AI_LOOK, unicode:characters_to_binary("AI看胜负")).

%% 准备倒计时
-define(READY_COUNT_DOWN,         10).
-define(ALL_NOT_READY_COUNT_DOWN, 25).

%% 比牌规则
-define(COMPARE_RULE_MAIN_CARD, 1).         %% 就比主力牌大小 花色
-define(COMPARE_RULE_ALL_CARDS, 2).         %% 比所有牌大小 比完再比花色
-define(COMPARE_RULE,           2).

-define(A_CAN_CONCAT_8_9_10_11, false).     %% A能跟8 9 10 J 连成顺子
-define(USE_A_MIN_SHUNZI,[14, 11, 10, 9, 8]).
-define(USE_A_MIN_SHUNZI_2,[14, 10, 9, 8]).

%% 行为分数权重  一次是胜率  摊牌率  入局1 入局2 入局3 入局4 allin
-define(ACTION_WEIGHT, [25, 20, 5, 5, 10, 14, 20]).

%% 随机桌子列表长度
-define(RANDOM_TABLE_LIST, 5).

-define(DEFAULT_SEQ, 0).

%% 百分比
-define(RANDOM100,   util:rand(1, 100)).
%% 万分比
-define(RANDOM10000, util:rand(1, 10000)).
%% 千分比
-define(RANDOM1000,  util:rand(1, 1000)).

%% ---------------------------
%% ets 
%% ---------------------------

-record(role_info, {
    id = 0,
    facelook = "",
    vip_lv = 0,
    name = "",
    table_coin = 0,
    init_coin = 0,
    all_coin = 0,
    charm = 0,
    pay = 0,            %% 玩家充值金额
    look = false,
	on_hook_num = 0,    %% 挂机次数
	is_time_out_give_up = 1, %% 是否超时弃牌(0:是, 1:不是)
	is_time_out_rang_pai = 0, %% 是否超时让牌(0:是, 1:不是)
    type = 0,           %% 0ai  1玩家
    ai_info = {},
    total_game_times = 0,
    win_game_times = 0,
    run_game_times = 0,
    total_win_coin = 0,
    total_xiazhu_coin = 0,
    ruju_1 = 0,
    ruju_2 = 0,
    ruju_3 = 0,
    ruju_4 = 0,
    liangpai = 0,
    allin = 0,
    action_grade = 0,
    system_control_times = 0,
    pid,
    chip = 0,           %% 已下筹码
    chair_id = 0,
    cards = [],         %% 已经发的牌
    all_cards = [],     %% 全部牌
    status = ?ROLE_STATE_READY %% 玩家状态  0围观 1准备  2 跟注  3 弃牌
}).

%% 桌子信息
-record(table_info, {
    table_id = 0,                %% 桌子ID
    lv = 0,
    status = ?TABLE_STATE_READY, %% 状态
    wait_time = 0,
    rebot_num = 0,
    start_time = 0,
    players = []                 %% 玩家id列表
}).

-define(ETS_SUOHA_SERVER, ets_suoha_server).
-record(ets_suoha_server,
{
    table_id = 0,
    lv = 0,
    num = 0,
    coin_list = [],
    coin_lv = 0,
    action_list = [],
    action_lv = 0,
    max_num = 0,
    room_type=0,                        %% 房间类型 0普通1私人房
    priv_id = 0,                        %% 私人房ID
    priv_pwd= 0,                        %% 私人房密码
    node = undefined                    %% 节点                                                                                                                 
}).


-record(suoha_ai_info, {
    game_type = ?AI_GAME_TYPE_PLAY_WITH,
    character = ?AI_CHARACTER_CONSERVATIVE  %% 性格
}).

-record(ets_enemy_cardslist, {
    id,
    cards
}).


%% Err 
%% ------------------------------------------------
-define(ERR_OK, 0).                                 %% 成功
-define(ERR_GOLD, 1).                               %% 钻石不足
-define(ERR_COIN, 2).                               %% 金币不足
-define(ERR_LOTTERY, 3).                            %% 奖券不足
-define(ERR_ITEMS_NOT_ENOUGH, 4).                   %% 道具不足

-define(ERR_SYSTEM, 99).                            %% 系统错误
%% 子游戏相关
-define(ERR_SUBGAME_IN, 23000).                     %% 已经在某个子游戏里了

%% 金花
-define(ERROR_CODE_NO_ROLE, 40001).                 %% 玩家不存在
-define(ERROR_CODE_STATUS_ERR, 40002).              %% 状态不对
-define(ERROR_CODE_TABLE_NOT_PLAYING, 40003).       %% 该桌子还未开始
-define(ERROR_CODE_IN_TABLE, 40004).                %% 玩家不在该桌子上
-define(ERROR_CODE_MAX_PLAYER, 40005).              %% 人数已到上限
-define(ERROR_CODE_NEED_PLAYER_MORE, 40006).        %% 玩家人数不足
-define(ERROR_CODE_TURN_ERR, 40007).                %% 还没有轮到你
-define(ERROR_CODE_XIAZHUTIMES_NOTENOUGH, 40009).   %% 手数还没有达到 不能看牌
-define(ERROR_CODE_NOT_MATCH_COMPARE_TIMES, 40010). %% 还未达到可比手数
-define(ERROR_CODE_COMPACE_REJECT, 40011).          %% 玩家拒绝比牌
-define(ERROR_CODE_MONEY_NOT_ENOUGH, 40014).        %% 金币不够
-define(ERROR_CODE_REJECT_FAIL_FOR_LOOK, 40015).    %% 已看牌不能拒绝
-define(ERROR_CODE_REJECT_FAIL_FOR_OUT_REJECTTIMES, 40016). %% 已经超出拒绝比牌次数上限
-define(ERROR_CODE_GUZHUYIZHI_MONEY, 40017).        %% 金币不满足孤注一掷的条件
-define(ERROR_CODE_REQUEST_VALID, 40018).           %% 非法请求
-define(ERROR_CODE_OUT_LOOP_TOP, 40019).            %% 超过单轮下注封顶
-define(ERROR_CODE_SYSTEM_ERR, 40020).              %% 系统错误
-define(ERROR_CODE_CONFIG_ERR, 40021).              %% 配置错误
-define(ERROR_CODE_ALL_AI, 40022).                  %% 全部都是AI了
-define(ERROR_CODE_ALLIN_DONE, 40023).              %% 已经有人allin了
-define(ERROR_CODE_CANNOT_LOOP_JIAZHU, 40024).      %% 当前轮不能加注
-define(ERROR_CODE_NOT_MATCH_COIN, 40026).          %% 金币不匹配该房间
-define(ERROR_CODE_IN_OTHER_GAME, 40027).           %% 玩家在其它的游戏中
-define(ERROR_CODE_NO_XIAZHU_LONG_TIME, 40028).     %% 长时间没下注
%% 梭哈
-define(ERROR_CODE_NOT_YOUR_TURN, 41007).           %% 还没有轮到你呢
-define(ERROR_CODE_CANNOT_RANGPAI, 41008).          %% 已经有人下注了 不能让牌
-define(ERROR_CODE_CANNOT_KAIPAI_LOOP, 41009).      %% 本轮不能开牌
-define(ERROR_CODE_CANNOT_KAIPAI, 41010).           %% 已经有人下注 不能开牌
-define(ERROR_CODE_SUOHA, 41011).                   %% 已经梭哈了
-define(ERROR_CODE_JIAZHU_ERROR, 41013).            %% 加注超上限了
-define(ERROR_CODE_MONEY_JIAZHU_TIMES_MAX, 41015).  %% 加注次数达到上限
-define(ERROR_CODE_SUOHA_ERR, 41019).               %% 已经有人下注了 不能梭哈
-define(ERROR_CODE_COIN_MORE, 41021).               %% 金币超系统进入上限
-define(ERROR_CODE_ONLY_ONE, 41024).                %% 最后一个人了
-define(ERROR_CODE_ROLE_MONEY, 41025).              %% 超过玩家金币上限
-define(ERROR_CODE_ERR_COIN, 41026).                %% 输入金币数量错误

-define(ERROR_CODE_VIP_LIMIT, 4102001).             %% VIP级别不够
-define(ERROR_CODE_IN_GAME, 4102002).               %% 玩家在游戏中
-define(ERROR_CODE_MATCH_CFG,4102003).              %% 没有房间配置

-endif.


