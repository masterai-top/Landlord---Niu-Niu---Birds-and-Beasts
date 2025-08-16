-ifndef(__GOODS__).
-define(__GOODS__, goods).


-define(COIN_ID, 100001). %% 金币ID
-define(EXP_ID, 100002).  %% 经验ID


-define(GOODS_T_VIRTUAL, 0). %% 虚拟物品


-define(TURN_TABLE, 1).		%% 大转盘



%% 熔炼物品信息
-record(smelt_goods, {
		gtid = 0,   %% 熔炼的物品id
		vip = 0,    %% vip等级
		other = []  %% 其他数据
}).


-endif.