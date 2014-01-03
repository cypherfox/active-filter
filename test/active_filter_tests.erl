%% @author sage
%% @doc unit tests for the active filter behaviour.

-module(active_filter_tests).

%%
%% Include files
%%
-include_lib("eunit/include/eunit.hrl").

%%
%% Exported Functions
%%
-export([]).

%%
%% Fixtures
%%

info_test_() ->
    { setup, fun() -> ok end,
      fun() -> ?debugFmt("~n############################################~n      starting ~p~n############################################~n  ", [?MODULE]) end }.

callback_test_() ->
    { "test internal functions",
      setup,

      fun() ->
              %%     application:start(sasl),
              ok
      end,

      fun(_Args) ->
              %%     application:stop(sasl),
              ok
      end,
      fun(_Args) -> [
                    ?_test(test_init_stub()),
                    ?_test(test_handle_message_stub()),
					?_test(test_new_subscriber_stub()),
					?_test(test_subscriber_left_stub()),
					?_test(test_prep_hibernation_stub()),
					?_test(test_terminate_stub())
                   ]
      end }.

test_init_stub() ->
	ValidState = {some, valid, state},

	M = em:new(),
	em:strict(M, mock_active_filter, init, 
			  [fun is_list/1],
			  {return, {ok, ValidState}}),
	em:replay(M),

	?assertEqual({ok, ValidState}, active_filter:init_stub(mock_active_filter,[])),
	
	em:verify(M),
	
	ok.

test_handle_message_stub() ->
	M = em:new(),
	em:strict(M, mock_active_filter, handle_message, 
			  [fun any/1, fun any/1], 
			  {function, fun([_Msg, State]) -> State end}),
	em:replay(M),

	ValidState = {some, valid, state},
	
	?assertEqual(ValidState, 
				 active_filter:handle_message_stub(mock_active_filter,
												   {a_message, 42}, ValidState)),
	
	em:verify(M),
	
	ok.

any(_Arg) -> true.

test_new_subscriber_stub() ->
	M = em:new(),
	em:strict(M, mock_active_filter, new_subscriber, [fun is_pid/1, fun any/1]),
	em:replay(M),

	active_filter:new_subscriber_stub(mock_active_filter,self(),any_term),
	
	em:verify(M),

	ok.

test_subscriber_left_stub() ->
	M = em:new(),
	em:strict(M, mock_active_filter, subscriber_left, [fun is_pid/1]),
	em:replay(M),

	active_filter:subscriber_left_stub(mock_active_filter,self()),
	
	em:verify(M),

	ok.

test_prep_hibernation_stub() ->
	M = em:new(),
	em:strict(M, mock_active_filter, prep_hibernation, []),
	em:replay(M),

	active_filter:prep_hibernation_stub(mock_active_filter),
	
	em:verify(M),

	ok.

test_terminate_stub() ->
	M = em:new(),
	em:strict(M, mock_active_filter, terminate, []),
	em:replay(M),

	active_filter:terminate_stub(mock_active_filter),
	
	em:verify(M),

	ok.

