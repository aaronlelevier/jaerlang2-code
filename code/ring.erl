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
    RingSize = erlang:length(Pids),
    lists:foreach(
        fun({I, P}) -> P ! {atom_to_integer(name(next(I, RingSize))), M, Msg} end,
        lists:zip(
            lists:seq(1, RingSize),
            Pids
        )
    ).

start_procs(0, _, Procs) -> Procs;
start_procs(N, RingSize, Procs) ->
    Pid = spawn(?MODULE, loop, [N, RingSize]),
    true = register(name(N), Pid),
    start_procs(N-1, RingSize, [Pid|Procs]).

name(N) -> list_to_atom(integer_to_list(N)).

atom_to_integer(A) -> list_to_integer(atom_to_list(A)).

next(Index, RingSize) ->
    case Index =:= RingSize of
        true -> 1;
        false -> Index+1
    end.

loop(Origin, RingSize) ->
    receive
        {Index, M, Msg} ->
            case M =:= 0 of
                true ->
                    ?LOG({done, Index, M, Msg}),
                    ok;
                false ->
                    Next = next(Index, RingSize),
                    case Origin =:= Index of
                        true ->
                            ?LOG({decrement_m, Next, M, Msg}),
                            name(Next) ! {Index, M-1, Msg},
                            loop(Origin, RingSize);
                        false ->
                            ?LOG({send_next_i, Next, M, Msg}),
                            name(Next) ! {Next, M, Msg},
                            loop(Origin, RingSize)
                    end
            end
    end.

