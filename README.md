active-filter
=============

create a processing element that is active only if consumers of results are 
subscribed to it

copyright 2014 Lutz Behnke <lutz.behnke@gmx.de>

Behaviour API
-------------

active-filter provides an API for modules implementing filters. Theses are tasks
that are actively processing their input only if there are subscribers to the the
results. The filters do not need to maintain a seperate process by themselves.
Similar to gen_fsm, this is handled by the active-filter application.

init(StartArgs::list()) -> ok | {error, Reason::term()}
	start a filter. If this callback does not return ok, the filter
	will be aborted.

new_subscriber(Pid::pid(), AppData::term()) -> ok.
	a new subscriber has registered for the filter. AppData is arbitrary data sent
	by the subscriber to the filter.
	
subscriber_left(Pid::pid()) -> ok.
	a process has removed its subscription to this filter. There is no need for
	the filter to keep track of the subscribers. This is only an informational
	call.

handle_message(Message :: term(), State :: term()) -> 
        {ok, NewState :: term} | {error, Reason :: term()}.
    handle an incoming message. It is assumed that the filter is used inside a
    pub/sub infrastructure that will send messages to processes that have subscribed
    to them.
     	
prep_hibernation() -> ok.
	There are no subscribers left and the filter will be placed into a sleep state.
	
terminate() -> ok.
	prepare termination and removal of the filter.
	
Utility Functions for filters
-----------------------------

send_message(Message::term()) -> ok | {error, not_active} | {error, not_known}.
	will send a message from the filter to all its subscribers.
	
