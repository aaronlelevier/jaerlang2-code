%% ---
%%  Ch12 Concurrent Programming exercises - ex3
%%  Ring with N processes that sends a Msg around the ring M times so N * M msgs sent
%% ---
-module(ring).
-export([
    start/0,
    start/3,
    loop/2
]).

-define(LOG(X), io:format("~p:~p:~p ~p~n", [?MODULE, ?FILE, ?LINE, X])).


%%% Public %%%

% Hardcoded start params for testing. e.g.
% $ erlc ring.erl && erl -noshell -s ring start -s init stop
-spec start() -> ok.
start() ->
    start(3, 3, "yo").

% Main entrypoint. Sends 'Msg' around a ring of 'N' process 'M' times
-spec start(integer(), integer(), string()) -> ok.
start(N, M, Msg) ->
    Pids = start_procs(N, N, []),
    send(Msg, M, Pids).

% Main loop in charge of sending the 'Msg' around the ring
-spec loop(integer(), integer()) -> ok.
loop(Origin, RingSize) ->
    receive
        {Index, M, Msg} ->
            Next = next(Index, RingSize),
            case M =:= 0 of
                true ->
                    case Origin =:= Index of
                        true ->
                            ?LOG({done, Index, M, Msg}),
                            ok;
                        false ->
                            ?LOG({send_next_i_m, Next, M, Msg}),
                            name(Next) ! {Next, M, Msg},
                            loop(Origin, RingSize)
                    end;
                false ->
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


%%% Private %%%

% Starts all processes in the ring and registers them by their index
-spec start_procs(integer(), integer(), [pid()]) -> [pid()].
start_procs(0, _, Procs) -> Procs;
start_procs(N, RingSize, Procs) ->
    Pid = spawn(?MODULE, loop, [N, RingSize]),
    true = register(name(N), Pid),
    start_procs(N-1, RingSize, [Pid|Procs]).

% Once all processes have be started, this sends the initial 'Msg'
-spec send(string(), integer(), [pid()]) -> ok.
send(Msg, M, Pids) ->
    RingSize = erlang:length(Pids),
    lists:foreach(
        fun({I, P}) -> P ! {next(I, RingSize), M, Msg} end,
        lists:zip(
            lists:seq(1, RingSize),
            Pids
        )
    ).

-spec name(integer()) -> atom().
name(N) -> list_to_atom(integer_to_list(N)).

-spec next(integer(), integer()) -> integer().
next(Index, RingSize) ->
    case Index =:= RingSize of
        true -> 1;
        false -> Index+1
    end.
