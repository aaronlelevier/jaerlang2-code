%% ---
%%  Ch8 exercises
%%---
-module(ch8_ex1).
-export([
    dict_count_exports/0,
    most_exports/0,
    most_common_name/0
]).


% Returns the number of exported functions by the 'map' module
dict_count_exports() ->
    length(dict:module_info(exports)).


% Returns the module with the most exported functions
most_exports() ->
    lists:max([{length(Mod:module_info(exports)), Mod} || {Mod,_} <- code:all_loaded()]).


% Returns the most common function name across all modules
most_common_name() ->
    most_common_name(code:all_loaded(), #{}).
most_common_name([], Map) -> map_max(maps:iterator(Map), {undefined, 0});
most_common_name([{Mod, _}|T], Map) ->
    Map2 = lists:foldl(
        fun({FName, _Arity}, M) ->
            M#{FName => maps:get(FName, M, 0)+1}
        end,
        Map,
        Mod:module_info(exports)
    ),
    most_common_name(T, Map2).
map_max(none, {Fname, N}) -> {Fname, N};
map_max(I, {Fname, N}) ->
    {K, V, I2} = maps:next(I),
    case V > N of
        true -> map_max(I2, {K, V});
        false -> map_max(I2, {Fname, N})
    end.
