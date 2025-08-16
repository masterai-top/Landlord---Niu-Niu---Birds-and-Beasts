-ifndef(DEFINE_REDPACKETS_HRL).
-define(DEFINE_REDPACKETS_HRL,0).

%% ets_db_name
%% --------------------------------------------------
-define(DB_NAME_REDPACKET, red_packets_plaza).


-define(OP_SEND, 0).         %% 发红包
-define(OP_RECV, 1).         %% 收红包
-define(OP_TIMEOUT, 2).      %% 过期回退 
-define(REDPACKET_TIME,7200).%% 过期时间

%% return code
%% ---------------------------------------------------
-define(PT_35_SUCCESS, 0).          %% 成功
-define(PT_35000, 1).
-define(PT_35000_RANGE, 3500001).   %% 设置红包金币上下限
-define(PT_35000_COIN,  3500002).   %% 玩家金币不足
-define(PT_35000_VIP,   3500003).   %% 玩家VIP级别不够

-define(PT_35002, 1).
-define(PT_35002_EXISTS, 3500201).   %% 红包不存在
-define(PT_35002_HASRED, 3500202).   %% 红包不是玩家发的
-define(PT_35002_HASGRAP,3500203).   %% 红包已经被抢


-define(PT_35004, 1).
-define(PT_35004_EXISTS, 3500401).   %% 红包不存在
-define(PT_35004_SELFRED,3500402).   %% 红包是玩家发的
-define(PT_35004_HASGRAP,3500403).   %% 红包已经被抢
-define(PT_35004_COINERR,3500404).   %% 红包金币数量不对
-define(PT_35004_GUSSTIME,3500405).  %% 拆红包次数上限
-endif.