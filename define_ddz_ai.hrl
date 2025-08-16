-ifndef(DEFINE_DDZ_AI_HRL).
-define(DEFINE_DDZ_AI_HRL,0).
-include("room.hrl").
% -------------------------------------------------------
% MACRO
% -------------------------------------------------------
-define(TB_LANDER, 1).		%% 地主
-define(TB_PRE_FARMER, 0).	%% 地主上家
-define(TB_SUB_FARMER, 2).	%% 地主下家


-define(TB_OPER_PLAY, 1).   %% 出牌
-define(TB_OPER_FOLLOW, 2). %% 跟牌

%% AI计算方式 本地计算/独立节点计算
-define(DEF_CAL_NODE, true).

-define(MAX_PROCESS,  200).


%%　anylyse_weight_poke结果集映射关系
-define(Fileds,
        [{dans,     1},
         {duis,     2},
         {sans,     3},
         {shuns,    4},
         {lianduis, 5},
         {sandaiyis,6},
         {sandaiers,7},
         {feijis,   8},
         {zhadans,  9},
         {wangzha, 10}]).


%% analyse_poke:结果集{Shunzis, Wangzha, Zhadans, Sanzhangs, Duizis, Dans}
-define(AnalyseFileds,
       [{shunzis,  1},
        {wangzha,  2},
        {zhadans,  3},
        {sanzhangs,4},
        {duis,     5},
        {dans,     6}]).

% -------------------------------------------------------
% Record 
% -------------------------------------------------------
%% 玩家Round过程状态，决策依据
-record(round_state,{
    player_id = 0,			%% 玩家ID
    player_status = 0,		%% 地主 或 农民身份：0 普通，1 农民，2 地主
    player_pos = 0,			%% 玩家所处位置 0：地主上家 1：地主  2:地主下家
    is_crisis = 0,          %% 告警状态 　0：未报警 1：报警状态
    rival_num = 0,          %% 最少牌敌方牌的数量
    rival_robot = 0,        %% 敌对是机器人
    open_deal = 0,          %% 明牌 0不明牌1明牌
    min_card  = 0,          %% 玩家手里最小牌
    rival_pos = 0,          %% 最少牌玩家位置
    oper_type = 0,          %% 操作类型　 1:出牌,2:跟牌  
    lzcards_num=0,          %% 赖子牌数量
    lzcards = [],           %% 赖子牌
    is_robot = 0,           %% 当前机器人0:否 1:是
	round_his=[]			%% 出牌
    }).

%% Ai 服务器状态
-define(ETS_AI_SERVER, ets_ai_server).
-record(ai_server,{
	ai_id = 0,	
	ai_name = undefined,	% AI进程名
	ai_state = 0			% 0空闲１占用				   
}).


-define(AI_STA_FREE, 0).
-define(AI_STA_BUSY, 1).

-define(DEAL_TYPE_0, 0).        %% 普通场
-define(DEAL_TYPE_1, 1).        %% 欢乐场

%% ------------------------------------------
%% -eq   //等于
%% -ge   //大于等于
%% -gt   //大于
%% -le   //小于等于
%% -lt   //小于
%% -ne   //不等于
%% {[分值,手数 ],{叫地主 抢地主 加倍}}
%% 欢乐斗地主行为分析表
%% 不洗牌斗地主
%% ------------------------------------------
%% 欢乐斗地主一-20%
-define(DDZ_ACT_RULE_1,[
{[{ge,10},{lt,7}],{100,100,100}},
{[{ge,10},{eq,7}],{100,100,100}},
{[{ge,10},{gt,7}],{100,100,50}},
{[{ge,9}, {lt,7}],{100,50,50}},
{[{ge,9}, {eq,7}],{100,80,50}},
{[{ge,9}, {gt,7}],{100,80,0}},
{[{ge,8}, {lt,7}],{100,50,0}},
{[{ge,8}, {eq,7}],{100,20,0}},
{[{ge,8}, {gt,7}],{0,0,0}},
{[{ge,7}, {lt,7}],{100,0,0}},
{[{ge,7}, {eq,7}],{100,0,0}},
{[{ge,7}, {gt,7}],{0,0,0}}
]).
%% 欢乐斗地主二-60%
-define(DDZ_ACT_RULE_2,[
{[{ge,12},{lt,7}],{100,100,100}},
{[{ge,12},{eq,7}],{100,100,100}},
{[{ge,12},{gt,7}],{100,100,50}},
{[{ge,11}, {lt,7}],{100,80,80}},
{[{ge,11}, {eq,7}],{100,80,50}},
{[{ge,11}, {gt,7}],{100,80,0}},
{[{ge,10}, {lt,7}],{100,50,0}},
{[{ge,10}, {eq,7}],{100,20,0}},
{[{ge,10}, {gt,7}],{100,0,0}},
{[{ge,9}, {lt,7}],{100,0,0}},
{[{ge,9}, {eq,7}],{100,0,0}},
{[{ge,9}, {gt,7}],{0,0,0}}
]).
%% 欢乐斗地主三-20%
-define(DDZ_ACT_RULE_3,[
{[{ge,15},{lt,7}],{100,100,100}},
{[{ge,15},{eq,7}],{100,100,100}},
{[{ge,15},{gt,7}],{100,100,50}},
{[{ge,14},{lt,7}],{100,80,80}},
{[{ge,14},{eq,7}],{100,80,50}},
{[{ge,14},{gt,7}],{100,80,0}},
{[{ge,13},{lt,7}],{100,50,0}},
{[{ge,13},{eq,7}],{100,20,0}},
{[{ge,13},{gt,7}],{100,0,0}},
{[{ge,12},{lt,7}],{100,0,0}},
{[{ge,12},{eq,7}],{100,0,0}},
{[{ge,12},{gt,7}],{0,0,0}}
]).




%% 不洗牌斗地主一-20%
-define(DDZ_DEAL_RULE_1,[
{[{ge,14},{lt,5}],{100,100,100}},
{[{ge,14},{eq,5}],{100,100,100}},
{[{ge,14},{gt,5}],{100,100,50}},
{[{ge,13},{lt,5}],{100,80,80}},
{[{ge,13},{eq,5}],{100,80,40}},
{[{ge,13},{gt,5}],{100,60,0}},
{[{ge,12},{lt,5}],{100,60,0}},
{[{ge,12},{eq,5}],{100,20,0}},
{[{ge,12},{gt,5}],{100,2,0}},
{[{ge,11},{lt,5}],{100,30,0}},
{[{ge,11},{eq,5}],{100,10,10}},
{[{ge,11},{gt,5}],{0,0,0}}
]).
%% 不洗牌斗地主二-60%
-define(DDZ_DEAL_RULE_2,[
{[{ge,16},{lt,5}],{100,100,100}},
{[{ge,16},{eq,5}],{100,100,100}},
{[{ge,16},{gt,5}],{100,100,50}},
{[{ge,15},{lt,5}],{100,80,80}},
{[{ge,15},{eq,5}],{100,80,40}},
{[{ge,15},{gt,5}],{100,60,0}},
{[{ge,14},{lt,5}],{100,60,0}},
{[{ge,14},{eq,5}],{100,20,0}},
{[{ge,14},{gt,5}],{100,2,0}},
{[{ge,13},{lt,5}],{100,30,0}},
{[{ge,13},{eq,5}],{100,10,10}},
{[{ge,13},{gt,5}],{0,0,0}}
]).
%% 不洗牌斗地主三-20%
-define(DDZ_DEAL_RULE_3,[
{[{ge,20},{lt,5}],{100,100,100}},
{[{ge,20},{eq,5}],{100,100,100}},
{[{ge,20},{gt,5}],{100,100,50}},
{[{ge,18},{lt,5}],{100,80,80}},
{[{ge,18},{eq,5}],{100,80,40}},
{[{ge,18},{gt,5}],{100,60,0}},
{[{ge,17},{lt,5}],{100,60,0}},
{[{ge,17},{eq,5}],{100,20,0}},
{[{ge,17},{gt,5}],{100,2,0}},
{[{ge,16},{lt,5}],{100,30,0}},
{[{ge,16},{eq,5}],{100,10,10}},
{[{ge,16},{gt,5}],{0,0,0}}
]).


%% 叫牌分数表
%% -------------------------------     
%%     1、叫抢地主牌型分数表                 
%%     牌型/分值   极小牌 小牌  中牌  大牌  特殊
%%     火箭  6   -   -   -   -
%%     大王  2.5 -   -   -   -
%%     小王  2   -   -   -   -
%%     炸弹  4   4   5   5   -
%%     单2  1.5 -   -   -   -
%%     飞机  2   2   3   4   乘以 牌力值比
%%     连对  1   1   2   3   乘以 牌力值比
%%     顺子  1   1   1.5 2   "乘以 牌力值比如3456789的分值 = 3456789的牌力值/34567的牌力值*分值"
%%     三张  0   1   1.5 2   -
%%     对子  0   0   1   1.5 
%% --------------------------------  
-define(JIAOPAI_RULE,[
    #{type=>?CARD_TYPE_WANG_ZHA,  key => 16,gt=>6}, 
    #{type=>?CARD_TYPE_DAN_ZHANG, key => 17,gt=>2.5},   
    #{type=>?CARD_TYPE_DAN_ZHANG, key => 16,gt=>2},   
    #{type=>?CARD_TYPE_DAN_ZHANG, key => 15,gt=>1.5},   
    #{type=>?CARD_TYPE_ZHA_DAN,   gt=>5, mid=>5,  lt=>4, ty=>4},   
    #{type=>?CARD_TYPE_LIAN_DUI,  gt=>3, mid=>2,  lt=>1, ty=>1},   
    #{type=>?CARD_TYPE_DAN_SHUN,  gt=>2, mid=>1.5,lt=>1, ty=>1},   
    #{type=>?CARD_TYPE_FEI_JI,    gt=>4, mid=>3,  lt=>2, ty=>2},
    #{type=>?CARD_TYPE_CHI_BANG1, gt=>4, mid=>3,  lt=>2, ty=>2},
    #{type=>?CARD_TYPE_CHI_BANG2, gt=>4, mid=>3,  lt=>2, ty=>2},     
    #{type=>?CARD_TYPE_SAN_ZHANG, gt=>2, mid=>1.5,lt=>1, ty=>1}, 
    #{type=>?CARD_TYPE_SAN_DAI_YI,gt=>2, mid=>1.5,lt=>1, ty=>1},
    #{type=>?CARD_TYPE_SAN_DAI_ER,gt=>2, mid=>1.5,lt=>1, ty=>1},  
    #{type=>?CARD_TYPE_SHUANG,    gt=>1.5,mid=>1, lt=>0, ty=>0}
]).




%% -------------------------------  
%% 绝对手数计算表
%%  {id=>(1:绝对领大,2:相对领大,3:普通牌型),
%%  type=>牌型,
%%  play=>出p
%%  follow=>跟牌}
%% -------------------------------  
-define(POKE_HANDS_RULE,#{
    %%领大
    201=>#{id=>2,type=>?CARD_TYPE_DAN_ZHANG,play=>-1,follow=>-1},
    202=>#{id=>2,type=>?CARD_TYPE_SHUANG,   play=>-1,follow=>-1},
    203=>#{id=>2,type=>?CARD_TYPE_SAN_ZHANG,play=>-1,follow=>-1},
    204=>#{id=>2,type=>?CARD_TYPE_SAN_DAI_YI,play=>-1,follow=>-1},
    205=>#{id=>2,type=>?CARD_TYPE_SAN_DAI_ER,play=>-1,follow=>-1},
    206=>#{id=>2,type=>?CARD_TYPE_DAN_SHUN, play=>-1,follow=>0},
    207=>#{id=>2,type=>?CARD_TYPE_LIAN_DUI, play=>-1,follow=>0},
    208=>#{id=>2,type=>?CARD_TYPE_FEI_JI,   play=>-1,follow=>0},
    209=>#{id=>2,type=>?CARD_TYPE_CHI_BANG1,play=>-1,follow=>0},
    210=>#{id=>2,type=>?CARD_TYPE_CHI_BANG2,play=>-1,follow=>0},

    %%普通
    301=>#{id=>3,type=>?CARD_TYPE_DAN_ZHANG,play=>1,follow=>1},
    302=>#{id=>3,type=>?CARD_TYPE_SHUANG,   play=>1,follow=>1},
    303=>#{id=>3,type=>?CARD_TYPE_SAN_ZHANG,play=>1,follow=>1},
    304=>#{id=>3,type=>?CARD_TYPE_SAN_DAI_YI,play=>1,follow=>1},
    305=>#{id=>3,type=>?CARD_TYPE_SAN_DAI_ER,play=>1,follow=>1},
    306=>#{id=>3,type=>?CARD_TYPE_DAN_SHUN, play=>1,follow=>1},
    307=>#{id=>3,type=>?CARD_TYPE_LIAN_DUI, play=>1,follow=>1},
    308=>#{id=>3,type=>?CARD_TYPE_FEI_JI,   play=>1,follow=>1},
    309=>#{id=>3,type=>?CARD_TYPE_CHI_BANG1,play=>1,follow=>1},
    310=>#{id=>3,type=>?CARD_TYPE_CHI_BANG2,play=>1,follow=>1}
    }).

%%敌方额外炸弹>0时
-define(POKE_HANDS_RULE_HAS_BOMBS,#{
    %%领大
    201=>#{id=>2,type=>?CARD_TYPE_DAN_ZHANG,play=>0,follow=>1},
    202=>#{id=>2,type=>?CARD_TYPE_SHUANG,   play=>0,follow=>1},
    203=>#{id=>2,type=>?CARD_TYPE_SAN_ZHANG,play=>0,follow=>1},
    204=>#{id=>2,type=>?CARD_TYPE_SAN_DAI_YI,play=>0,follow=>1},
    205=>#{id=>2,type=>?CARD_TYPE_SAN_DAI_ER,play=>0,follow=>1},
    206=>#{id=>2,type=>?CARD_TYPE_DAN_SHUN, play=>0,follow=>1},
    207=>#{id=>2,type=>?CARD_TYPE_LIAN_DUI, play=>0,follow=>1},
    208=>#{id=>2,type=>?CARD_TYPE_FEI_JI,   play=>0,follow=>1},
    209=>#{id=>2,type=>?CARD_TYPE_CHI_BANG1,play=>0,follow=>1},
    210=>#{id=>2,type=>?CARD_TYPE_CHI_BANG2,play=>0,follow=>1},

    %%普通
    301=>#{id=>3,type=>?CARD_TYPE_DAN_ZHANG,play=>1,follow=>1},
    302=>#{id=>3,type=>?CARD_TYPE_SHUANG,   play=>1,follow=>1},
    303=>#{id=>3,type=>?CARD_TYPE_SAN_ZHANG,play=>1,follow=>1},
    304=>#{id=>3,type=>?CARD_TYPE_SAN_DAI_YI,play=>1,follow=>1},
    305=>#{id=>3,type=>?CARD_TYPE_SAN_DAI_ER,play=>1,follow=>1},
    306=>#{id=>3,type=>?CARD_TYPE_DAN_SHUN, play=>1,follow=>1},
    307=>#{id=>3,type=>?CARD_TYPE_LIAN_DUI, play=>1,follow=>1},
    308=>#{id=>3,type=>?CARD_TYPE_FEI_JI,   play=>1,follow=>1},
    309=>#{id=>3,type=>?CARD_TYPE_CHI_BANG1,play=>1,follow=>1},
    310=>#{id=>3,type=>?CARD_TYPE_CHI_BANG2,play=>1,follow=>1}
    }).
    
%敌方额外炸弹=0时
-define(POKE_HANDS_RULE_NO_BOMBS,#{
    %%领大
    201=>#{id=>2,type=>?CARD_TYPE_DAN_ZHANG,play=>-1,follow=>-1},
    202=>#{id=>2,type=>?CARD_TYPE_SHUANG,   play=>-1,follow=>-1},
    203=>#{id=>2,type=>?CARD_TYPE_SAN_ZHANG,play=>-1,follow=>-1},
    204=>#{id=>2,type=>?CARD_TYPE_SAN_DAI_YI,play=>-1,follow=>-1},
    205=>#{id=>2,type=>?CARD_TYPE_SAN_DAI_ER,play=>-1,follow=>-1},
    206=>#{id=>2,type=>?CARD_TYPE_DAN_SHUN, play=>0,follow=>0},
    207=>#{id=>2,type=>?CARD_TYPE_LIAN_DUI, play=>0,follow=>0},
    208=>#{id=>2,type=>?CARD_TYPE_FEI_JI,   play=>0,follow=>0},
    209=>#{id=>2,type=>?CARD_TYPE_CHI_BANG1,play=>0,follow=>0},
    210=>#{id=>2,type=>?CARD_TYPE_CHI_BANG2,play=>0,follow=>0},

    %%普通
    301=>#{id=>3,type=>?CARD_TYPE_DAN_ZHANG,play=>1,follow=>1},
    302=>#{id=>3,type=>?CARD_TYPE_SHUANG,   play=>1,follow=>1},
    303=>#{id=>3,type=>?CARD_TYPE_SAN_ZHANG,play=>1,follow=>1},
    304=>#{id=>3,type=>?CARD_TYPE_SAN_DAI_YI,play=>1,follow=>1},
    305=>#{id=>3,type=>?CARD_TYPE_SAN_DAI_ER,play=>1,follow=>1},
    306=>#{id=>3,type=>?CARD_TYPE_DAN_SHUN, play=>1,follow=>1},
    307=>#{id=>3,type=>?CARD_TYPE_LIAN_DUI, play=>1,follow=>1},
    308=>#{id=>3,type=>?CARD_TYPE_FEI_JI,   play=>1,follow=>1},
    309=>#{id=>3,type=>?CARD_TYPE_CHI_BANG1,play=>1,follow=>1},
    310=>#{id=>3,type=>?CARD_TYPE_CHI_BANG2,play=>1,follow=>1}
    }).

%% 联接策略
%% -------------------------------
-define(LTYPE_DAN_LT,1).            %% 单从小跟
-define(LTYPE_DAN_GT,99).           %% 单从大跟 
-define(LTYPE_ER_DAN,2).            %% 2当单张跟
-define(LTYPE_ER_DUI,3).            %% 2当对子跟

-endif.