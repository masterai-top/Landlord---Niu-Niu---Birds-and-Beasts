%% @author Administrator
%% @doc @todo Add description to server_manager.


-module(server_manager).

%% ====================================================================
%% API functions
%% ====================================================================
-export([stop/1, update/1, test/0]).

%% ====================================================================
%% Internal functions
%% ====================================================================

%% 停服
stop([GateWayNode | _]) ->
	Node = tool:to_atom(GateWayNode),
	timer:sleep(2 * 1000),
	case net_adm:ping(Node) of
		pong ->
			io:format("~n====stopping====server===~n"),
			rpc:cast(Node, misc_admin, safe_quit, [[]]),
			timer:sleep(1 * 60 * 1000),
			erlang:halt();
		_ ->
			io:format("~n====can==not==connect=node:~p===~n", [Node])
	end;
stop(_Data) ->
	io:format("~n====stop==peram==error=Data:~p==~n", [_Data]).

%% 热更
update([GateWayNode | _]) ->
	Node = tool:to_atom(GateWayNode),
	timer:sleep(5 * 1000),
	case net_adm:ping(Node) of
		pong ->
			io:format("~n====compile====code===~n"),
			rpc:cast(Node, u, c, []),
			timer:sleep(15 * 1000),
			io:format("~n====loading===code===~n"),
			rpc:cast(Node, u, u, []),
			timer:sleep(30 * 1000),
			erlang:halt();
		_ ->
			io:format("~n====can==not==connect=node:~p===~n", [Node])
	end;
update(_Data) ->
	io:format("~n====update==peram==error=Data:~p==~n", [_Data]).

test() ->
	io:format("~n=====testing===code==update=====~n"),
	io:format("~n=====testing===code==update==success==2223331====~n"),
	ok.