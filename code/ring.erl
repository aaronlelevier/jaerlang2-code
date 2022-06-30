%% ---
%%  Ch12 Concurrent Programming exercises - ex3
%%  Ring with N processes that sends a Msg around the ring M times so N * M msgs sent
%% ---
-module(ring).
-export([
    start/3,
    loop/2
]).

-define(LOG(X), io:format("~p:~p:~p ~p~n", [?MODULE, ?FILE, ?LINE, X])).

start(N, M, Msg) ->
    Pids = start_procs(N, N, []),
    send(Msg, M, Pids).

send(Msg, M, Pids) ->
    Ps = lists:zip(
        lists:seq(1, erlang:length(Pids)),
        Pids
    ),
    [lists:foreach(
        fun({Index, Pid}) -> Pid ! {Index, Mi, Msg} end,
        Ps)
    || Mi <- lists:seq(1,M)
    ].

start_procs(0, _RingSize, Procs) -> Procs;
start_procs(N, RingSize, Procs) ->
    Pid = spawn(?MODULE, loop, [N, RingSize]),
    start_procs(N-1, RingSize, [Pid|Procs]).

loop(Index, RingSize) ->
    receive
    {Index, Mi, Text} ->
        ?LOG({done, Index, Mi, Text}),
        loop(Index, RingSize);
    {Origin, Mi, Text} ->
        ?LOG({send, Origin, Mi, Text}),
        loop(Index, RingSize)
    end.
