%% ---
%%  ch6 ex1
%%---
-module(myfile).
-export([
    file/1
]).

file(File) ->
    case file:read_file(File) of
        {ok, Bin} -> Bin;
        {error, Why} ->
            throw(lists:flatten(io_lib:format("~p: ~s", [Why, File])))
    end.
