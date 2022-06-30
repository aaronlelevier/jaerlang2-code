%% ---
%% Ch12 Concurrent Programming exercises
%% ---
-module(ch12_ex1).
-export([
    start_register/1
]).

start_register(Name) ->
    {
        pass_badarg(fun() -> reg(Name) end),
        pass_badarg(fun() -> reg(Name) end)
    }.

reg(Name) ->
    Pid = erlang:spawn(fun area_server0:loop/0),
    true = register(Name, Pid),
    Pid.

pass_badarg(Fun) ->
    try Fun() of
        X -> {ok, X}
    catch
        error:badarg -> {error, badarg}
    end.
