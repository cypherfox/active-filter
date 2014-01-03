%% @author sage
%% @doc @todo Add description to active_filter.


-module(active_filter).

-callback init(Args :: [term()]) -> {ok, State :: term()} | {error, Reason::term()}.
-callback handle_message(Msg :: term(), State :: term()) -> NewState :: term().
-callback new_subscriber(Pid::pid(), AppData::term()) -> ok.
-callback subscriber_left(Pid::pid()) -> ok.
-callback prep_hibernation() -> ok.


%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").


%% ====================================================================
%% API functions
%% ====================================================================
-export([]).

-ifdef(TEST).
%% export the private functions for testing only.
-export([init_stub/2, handle_message_stub/3, 
		 new_subscriber_stub/3, subscriber_left_stub/2, 
		 prep_hibernation_stub/1, terminate_stub/1]).
-endif.

%% ====================================================================
%% Internal functions
%% ====================================================================
init_stub(Mod,Args) -> Mod:init(Args).

handle_message_stub(Mod, Message, State) -> Mod:handle_message(Message, State).

new_subscriber_stub(Mod, Pid, AppData) -> Mod:new_subscriber(Pid, AppData).

subscriber_left_stub(Mod, Pid) -> Mod:subscriber_left(Pid).

prep_hibernation_stub(Mod) -> Mod:prep_hibernation().

terminate_stub(Mod) -> Mod:terminate().