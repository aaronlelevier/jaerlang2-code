%% ---
%%  Ch12 Concurrent Programming exercises - ex3
%%  Ring with N processes that sends a Msg around the ring M times so N * M msgs sent
%% ---
-module(ring).
-export([
    start/2,
    loop/2
]).

-define(LOG(X), io:format("~p:~p:~p ~p~n", [?MODULE, ?FILE, ?LINE, X])).

start(N, _M) ->
    Procs = start_procs(N, N, []),
    Procs.

start_procs(0, _RingSize, Procs) -> Procs;
start_procs(N, RingSize, Procs) ->
    Pid = spawn(?MODULE, loop, [N, RingSize]),
    start_procs(N-1, RingSize, [Pid|Procs]).

loop(Index, RingSize) ->
    receive
    {Index, Text} ->
        ?LOG({done, Index, Text}),
        loop(Index, RingSize);
    {Origin, Text} ->
        ?LOG({send, Origin, Text}),
        loop(Index, RingSize)
    end.
