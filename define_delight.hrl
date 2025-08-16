-ifndef(DEFINE_DELIGHT_HRL).
-define(DEFINE_DELIGHT_HRL,0).
-include("record/data_player_label_control_record.hrl").
%% 快乐值标签 
-define(DELIGHT_WIN,   1).
-define(DELIGHT_WIN_1, 2).
-define(DELIGHT_WIN_2, 3).
-define(DELIGHT_WIN_3, 4).
-define(DELIGHT_WIN_4, 5).
-define(DELIGHT_WIN_5, 6).
-define(DELIGHT_UP, 7).
-define(DELIGHT_SPRING, 8).
-define(DELIGHT_LUCKY,  9).

-define(DELIGHT_LOS,   11).
-define(DELIGHT_LOS_1, 12).
-define(DELIGHT_LOS_2, 13).
-define(DELIGHT_LOS_3, 14).
-define(DELIGHT_LOS_4, 15).
-define(DELIGHT_LOS_5, 16).
-define(DELIGHT_DOWN,  17).
-define(DELIGHT_SPRINGED, 18).

%% 快乐值－表项 对照表
-define(LABEL_CONTROL,
       [{?DELIGHT_WIN,   #player_label_control_config.win},
        {?DELIGHT_WIN_1, #player_label_control_config.win1},
        {?DELIGHT_WIN_2, #player_label_control_config.win2},
        {?DELIGHT_WIN_3, #player_label_control_config.win3},
        {?DELIGHT_WIN_4, #player_label_control_config.win4},
        {?DELIGHT_WIN_5, #player_label_control_config.win5},
        {?DELIGHT_UP,    #player_label_control_config.up},
        {?DELIGHT_SPRING,#player_label_control_config.spring},
        {?DELIGHT_LUCKY, #player_label_control_config.lucky},
        {?DELIGHT_LOS,   #player_label_control_config.lost},
        {?DELIGHT_LOS_1, #player_label_control_config.lost1},
        {?DELIGHT_LOS_2, #player_label_control_config.lost2},
        {?DELIGHT_LOS_3, #player_label_control_config.lost3},
        {?DELIGHT_LOS_4, #player_label_control_config.lost4},
        {?DELIGHT_LOS_5, #player_label_control_config.lost5},
        {?DELIGHT_DOWN,  #player_label_control_config.down},
        {?DELIGHT_SPRINGED, #player_label_control_config.springed}
       ]).


-endif.
