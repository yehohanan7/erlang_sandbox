-module(sellaprime_supervisor).
-behaviour(supervisor).
-export([
	 start_link/1,
	 start/0
        ]).

-export([
	 init/1
        ]).

-define(SERVER, ?MODULE).


start() ->
    {ok, Pid} = supervisor:start_link({local,?MODULE}, ?MODULE, _Arg = []),
    unlink(Pid).

start_link(Args) ->
    supervisor:start_link({local,?MODULE}, ?MODULE, Args).

init([]) ->
    gen_event:swap_handler(alarm_handler,
			   {alarm_handler, swap},
			   {my_alarm_handler, xyz}),
    {ok, {{one_for_one, 3, 10},
	  [{tag1,
	    {area_server, start_link, []},
	    permanent,
	    10000,
	    worker,
	    [area_server]},
	   {tag2,
	    {prime_server, start_link, []},
	    permanent,
	    10000,
	    worker,
	    [prime_server]}
	  ]}}.
    


