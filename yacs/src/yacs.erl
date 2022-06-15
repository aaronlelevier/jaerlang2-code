-module(yacs).

-export([
    load/1,
    map_search_pred/2
]).


% loads a JSON file and returns it as a map
-spec load(string()) -> map().
load(Path) ->
    {ok, Bin} = file:read_file(Path),
    jsx:decode(Bin, [{labels, atom}]).


map_search_pred(Map, Pred) ->
    map_search(Pred, maps:to_list(Map)).

map_search(_Pred, []) -> {error, not_found};
map_search(Pred, [{Key, Value}|T]) ->
    case Pred(Key, Value) of
        true -> {ok, {Key, Value}};
        false -> map_search(Pred, T)
    end.
