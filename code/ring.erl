%% ---
%%  Ch12 Concurrent Programming exercises - ex3
%%  Ring with N processes that sends a Msg around the ring M times so N * M msgs sent
%% ---
-module(ring).
-export([
    start/3,
    loop/2
]).

-define(LOG(X), io:format("~p:~p:~p ~p ~p~n", [?MODULE, ?FILE, ?LINE, registered_name(self()), X])).

start(N, M, Msg) ->
    Pids = start_procs(N, N, []),
    send(Msg, M, Pids).

send(Msg, M, Pids) ->
    lists:foreach(
        fun({Origin, Pid}) -> Pid ! {Origin, M, Msg} end,
        lists:zip(
            lists:seq(1, erlang:length(Pids)),
            Pids
        )
    ).

start_procs(0, _RingSize, Procs) -> Procs;
start_procs(N, RingSize, Procs) ->
    Pid = spawn(?MODULE, loop, [N, RingSize]),
    true = register(name(N), Pid),
    start_procs(N-1, RingSize, [Pid|Procs]).

name(N) -> list_to_atom(integer_to_list(N)).

registered_name(Pid) ->
    {registered_name, Name} = process_info(Pid, registered_name),
    Name.

loop(Origin, RingSize) ->
    receive
        {Index, M, Msg} ->
            case Origin == Index of
                true ->
                    case M == 0 of
                        true ->
                            ?LOG({done, Index, M, Msg}),
                            ok;
                        false ->
                            ?LOG({decrement_m, Index, M, Msg}),
                            name(1) ! {Index, M-1, Msg},
                            loop(Origin, RingSize)
                    end;
                false ->
                    case Index == RingSize of
                        true ->
                            Next = 1;
                        false ->
                            Next = Index+1
                    end,
                    ?LOG({send_next_i, Index, M, Msg}),
                    name(Next) ! {Index, M, Msg},
                    loop(Origin, RingSize)
            end
    end.
