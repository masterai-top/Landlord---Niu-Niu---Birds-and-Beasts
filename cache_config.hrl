-ifndef(CACHE_CONFIG_H).
-define(CACHE_CONFIG_H, 0).
-include("record.hrl").

%% 进程字典的配置
%% -----------------------------------------------------------------------------
-define(CACHE_TABLE_CONFIG,
    [
        %% --------------------------------------------------------------------
        %% {表, 操作标志字段, key, key下标, ErlangTerm(tuple/list底层自动处理)}
        %% --------------------------------------------------------------------
        {goods,
            0,
            {id},
            {#goods.id},
            []
        },

        {player_security,
            #player_security.db_op,
            {uid},
            {#player_security.uid},
            []
        },

        {player_redpackets,
            #player_redpackets.db_op,
            {player_id},
            {#player_redpackets.player_id},
            [#player_redpackets.red_record]
        },

        {player_suoha,
            #player_suoha.db_op,
            {pid},
            {#player_suoha.pid},
            []
        },

        {player_shop,
            0,
            {player_id},
            {#player_shop.player_id},
            [#player_shop.buy_history_list]
        },

        {player_receive_info,
            0,
            {player_id},
            {#player_receive_info.player_id},
            []
        },

        {player_mem_cards,
            #player_mem_cards.db_op,
            {uid},
            {#player_mem_cards.uid},
            []
        },

        {player_zhajinhua,
            #player_zhajinhua.db_op,
            {uid},
            {#player_zhajinhua.uid},
            []
        },
        
        {player_ninehalf,
            #player_ninehalf.db_op,
            {uid},
            {#player_ninehalf.uid},
            []
        },

        {player_poke_match,
            #player_poke_match.db_op,
            {uid},
            {#player_poke_match.uid},
            []
        },

        {player_by,
            #player_by.db_op,
            {player_id},
            {#player_by.player_id},
            [#player_by.cannon_his_list]
        },

        {player_oper_wish,
            #player_oper_wish.db_op,
            {uid},
            {#player_oper_wish.uid},
            [#player_oper_wish.wish_list]
        },

        {player_oper_7days,
            #player_oper_7days.db_op,
            {uid},
            {#player_oper_7days.uid},
            [#player_oper_7days.params]
        },

        {player_win_lose,
            #player_win_lose.db_op,
            {uid},
            {#player_win_lose.uid},
            []
        },

        {player_jackpot_race,
            #player_jackpot_race.db_op,
            {uid},
            {#player_jackpot_race.uid},
            [#player_jackpot_race.race_info]
        },

        {player_redblack,
            #player_redblack.db_op,
            {player_id},
            {#player_redblack.player_id},
            [#player_redblack.last_20_yazhu_coin_list,
                #player_redblack.last_20_ret_list,
                #player_redblack.picked_rank_list]
        },

        {player_limit_times,
            #player_limit_times.db_op,
            {uid},
            {#player_limit_times.uid},
            [#player_limit_times.limit_time,
                #player_limit_times.use_time]
        },

        {player_longhudou,
            #player_redblack.db_op,
            {player_id},
            {#player_redblack.player_id},
            [#player_redblack.last_20_yazhu_coin_list,
                #player_redblack.last_20_ret_list,
                #player_redblack.picked_rank_list]
        },
        
        {player_others,
            #player_others.db_op,
            {uid},
            {#player_others.uid},
            [#player_others.params]
        }


    ]).

%% Table 定义
%% -----------------------------------------------------------------------------
%% --------------------------------------------------------------------------------------------------------------------------------
%% {DB表名,    操作标志字段,        key,   key下标,        ErlangTerm(自动处理)   ets表名,      建表参数} %注意:db名和record名必须一致
%% {test_1,  #test_1.db_op,  {id},  {#test_1.id},  [#test_1.d],        ets_test_1, [public,set,named_table,{keypos,#test_1.id}]},
%% --------------------------------------------------------------------------------------------------------------------------------
-define(TB_PLAZA,
    {red_packets_plaza,
        #red_packets_plaza.db_op,
        {red_id},
        {#red_packets_plaza.red_id},
        [#red_packets_plaza.recv_list],
        ets_red_packets_plaza,
        [public, set, named_table, {keypos, #red_packets_plaza.red_id}]
    }).

%% 银商信息
-define(TB_PLAYER_COIN_MERCHANT,
    {player_coin_merchant,
        #player_coin_merchant.db_op,
        {uid},
        {#player_coin_merchant.uid},
        [],
        ets_player_coin_merchant,
        [public, set, named_table, {keypos, #player_coin_merchant.uid}]
    }).


-define(TB_BY_GLOBAL,
    {by_global,
        #by_global.db_op,
        {type},
        {#by_global.type},
        [#by_global.type],
        ets_by_global,
        [public, set, named_table, {keypos, #by_global.type}]
    }).

-define(TB_ASYNC_EVENT,
    {player_async_event,
        #player_async_event.db_op,
        {player_id},
        {#player_async_event.player_id},
        [#player_async_event.subgame_attr, #player_async_event.asyn_msg],
        ets_player_async_event,
        [public, set, named_table, {keypos, #player_async_event.player_id}]
    }).

%%　Ets配置
%% -----------------------------------------------------------------------------
%% Node(Gateway)
-define(ETS_CACHE_TABLE_CONFIG_GATEWAY,
    [

    ]).

%% Node(Server)
-define(ETS_CACHE_TABLE_CONFIG_SERVER,
    [
        ?TB_PLAZA
    ]).


%% Node(Center)
-define(ETS_CACHE_TABLE_CONFIG_CENTER,
    [
        ?TB_PLAZA,
        ?TB_BY_GLOBAL,
        ?TB_ASYNC_EVENT
    ]).

%% Node(Web:充值节点)
-define(ETS_CACHE_TABLE_CONFIG_WEB,
    [
        ?TB_PLAYER_COIN_MERCHANT
    ]).


-endif.