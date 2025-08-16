-ifndef(FOWLSBEASTS_HRL).
-define(FOWLSBEASTS_HRL, true).

%% 飞禽走兽管理
-record(fowlsbeasts_state, { 
	auto_room_id = 0, %% 当前房间id号(自动递增)
	all_count = 0,    %% 所有玩家总数
	room_list = [],   %% 房间列表[{room_id, num, state, time}]		
	join_list = []    %% 等待队列[uid,...]			  					   
    }).

%% 飞禽走兽房间信息
-record(fowlsbeasts_room, {
   id = 0,                 %% 房间id	
   rate_id = 0,            %% 倍率id, 当前使用的是哪个倍率组合						
   state = 0,              %% 状态(0: 不可押注状态 , 1：等待押注(3秒)，2：押注状态(倒计时20秒)，3：等待开奖(3秒), 4:开奖状态(第一次8秒,第二次5秒),  5:结算状态(8秒))
   time = 0,               %% 活动各状态结束时间，秒为单位
   is_another_game = 0,    %% 是否抽中鲨鱼, 0则不继续开奖, 1则再开一次奖
   player_num = 0,         %% 当前房间人数
   dealer_id = 0,          %% 庄家id, 值为玩家的id
   robot_dealer_info = [], %% 连庄次数(主要给机器人使用) [remain_num, left_coin] remain_num:连庄次数, left_coin机器人庄家剩余金币
   dealer_apply_list = [], %% 上庄申请列表 [{uid, nick, is_robot, apply_time, vip}, ...] is_robot是否是机器人(0:否, 1:是), apply_time申请时间, vip会员等级					  
   apply_robot_num = 0,    %% 当前申请上庄的机器人
   bet_value = 0,          %% 当前押注的总金额
   bet_list = [],          %% 全部押注列表[{uid, animal_id, coin, is_robot, rate}] is_robot是否是机器人(0:否, 1:是) animal_id:押注的动物id, coin:押注金额, rate:倍率
   bet_robot_num = 0,      %% 当前押注的机器人										 
   bet_player_list = [],   %% 当前押注人数列表[{uid, is_robot}, ...]
   win_info = [],          %% 中奖信息[{index, animal_id, type, rate}], index为动物布局序号, rate为倍率, type为动物类型
   player_list = [],       %% 玩家列表[{uid, nick, facelook, isLeave},...]  记录真实玩家 isLeave:(0:玩家已离开房间, 1:玩家还在房间)
   history_list = [],      %% 历史开奖记录 [animal_id, ...] 只记录动物id
   pay_list = [],          %% 充值列表[{uid, amount}, ...]
   numerator_list = [],    %% 盈利比分子列表[{uid, numerator}, ...]
   denominator_list = [],  %% 盈利比分母列表 [{uid, denominator}, ...]    
   room_pid = undefined    %% 房间进程id
   }).

%% 玩家信息
-record(ets_fb_player, {
    uid = 0,                %% 玩家id
    nick = "",              %% 玩家名
    facelook = 0,           %% 玩家头像id
    coin = 0,               %% 玩家当前的金币
    dealer_coin = 0,        %% 上庄携带的金币
    vip = 0,                %% vip等级
    pay_money = 0,          %% 充值金额（单位元）
    room_id = 0,            %% 房间id
    numerator = 0,          %% 盈利比的分子
    denominator = 0,        %% 盈利比的分母
    old_room_id = 0,        %% 上次退出的房间id
    is_robot = 0,           %% 是否是机器人(0:否, 1:是)
    is_dealer = 0,          %% 是否是庄家 (0:否, 1:是)
    is_apply_dealer = 0,    %% 是否已经申请上庄(0:否, 1:是), 当is_dealer为1时, 此值为0
    remain_dealer_num = 0,  %% 当前连庄次数						 
    level = 0,              %% 玩家等级
    bet_list = [],          %% 全部押注列表[{uid, animal_id, coin, is_robot}] animal_id:押注的动物id, coin:押注金额
    bet_value = 0,          %% 押注总金额
    node = undefined,       %% 节点
    pid = undefined,        %% 玩家进程id
    room_pid = undefined    %% 房间进程id
       }).


-define(FOWLSBEASTS_STATE, fowlsbeasts_state).

-define(FOWLSBEASTS_ROOM, fowlsbeasts_room).

-define(ETS_FB_PLAYER, ets_fb_player).

-define(LOT_NEXT_GAME_TIME, 0).             %% 下一局开始时间 

-define(FB_DRAW_TIME, [10, 13]).            %% 正常开奖时间 之前是11秒 现在是[7+3, 10+3]

-define(FORGIVE_FB_DRAW_TIME, [6, 7]).      %% 赠送的开奖时间 之前是8秒 现在是[3+3, 4+3]

-define(FB_WAITING_BET_TIME,  2).            %% 等待下注时间

-define(FB_WAITING_DRAW_TIME, 4).           %% 等待开奖时间

-define(FB_BALANCE_TIME, 3).                %% 结算时间，单位秒

-define(FB_JETTON_LIST, [1000, 10000, 100000, 1000000]). %% 筹码列表

-define(FB_ADD_ROBOT_PLAYER_TIME, 1).       %% 押注机器人加入时间 单位/秒

-define(SHARK_TYPE, 3).

-endif.