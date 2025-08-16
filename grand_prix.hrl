-ifndef(GRAND_PRIX_HRL_).
-define(GRAND_PRIX_HRL_, true).


-define(ETS_SEASON_RACE_RANK, ets_season_race_rank).
-define(CHANGE_POINT_DICT, change_point_dict). %% 积分变更的玩家列表

%% 排行榜玩家信息
-record(ets_player_rank_info, {
	uid = 0,               %% 玩家id
	nick = "",             %% 玩家昵称
	point = 0,             %% 玩家积分
	rank = 0,              %% 玩家排名
	reward_list = []       %% 奖励列表
}).

%% 排行榜信息
-record(ets_grand_prix_race_rank, {
							  group = 0,           %% 组id
							  level = 0,           %% 等级  
							  rank_time = 0,       %% 排序时间                            	
							  rank_list = []       %% 排序信息[#ets_player_rank_info{}],
							 }).

 
-endif.
