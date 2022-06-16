%% ---
%%  ch5 ex3
%%
%%  Advanced: Look up the manual pages for the Ruby hash class.
%%  Make a module of the methods in the Ruby class that you think
%%  would be appropriate to Erlang.
%%
%%  See: https://ruby-doc.org/core-3.1.2/Hash.html
%%---
-module(ruby_hash).
-export([
    any/2,
    compact/1
]).

any({Key, Value}, Map) ->
    lists:member({Key, Value}, maps:to_list(Map));
any(P, Map) when is_function(P) ->
    maps:size(maps:filter(P, Map)) > 0;
any(_Other, _Map) -> false.

% removes undefined values from a map
compact(Map) ->
    maps:filter(fun(_K,V) -> V =/= undefined end, Map).
