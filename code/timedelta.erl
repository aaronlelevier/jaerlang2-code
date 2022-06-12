%% ---
%%  datetime timedelta math
%%  This module is does datetime math based on a particular unit but is only
%%  correct if the next lower or higher unit isn't crossed
%%---
-module(timedelta).
-export([
    add/2
]).

-type dt_name() :: year | month | day | hour | minute | second.
-type dt_value() :: {dt_name(), integer()}.

-spec add(calendar:datetime(), [dt_value()]) -> calendar:datetime().
add({{Year, Mon, Day}, {Hour, Min, Sec}}, Opts) ->
    % https://www.erlang.org/doc/man/calendar.html#type-date
    Year2 = proplists:get_value(year, Opts, 0),
    Mon2 = proplists:get_value(month, Opts, 0),
    Day2 = proplists:get_value(day, Opts, 0),

    % https://www.erlang.org/doc/man/calendar.html#type-time
    Hour2 = proplists:get_value(hour, Opts, 0),
    Min2 = proplists:get_value(minute, Opts, 0),
    Sec2 = proplists:get_value(second, Opts, 0),

    {
        {Year+Year2, Mon+Mon2, Day+Day2},
        {Hour+Hour2, Min+Min2, Sec+Sec2}
    }.
