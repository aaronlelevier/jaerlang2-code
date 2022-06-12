%% ---
%%  Excerpted from "Programming Erlang, Second Edition",
%%  published by The Pragmatic Bookshelf.
%%  Copyrights apply to this code. It may not be used to create training material, 
%%  courses, books, articles, and the like. Contact us if you are in doubt.
%%  We make no guarantees that this code is fit for any purpose. 
%%  Visit http://www.pragmaticprogrammer.com/titles/jaerlang2 for more book information.
%%---
-module(ch4_ex3).

% Commenting out because calling a deprecated function and causing warning messages
% -export([
%     my_time_func/1,
%     my_date_string/0
% ]).


% my_time_func(F) ->
%     {MegaSecs, Secs, MicroSecs} = erlang:now(),

%     Ret = F(),

%     {MegaSecs2, Secs2, MicroSecs2} = erlang:now(),

%     io:format(
%         "MegaSecs:~w Secs:~w MicroSecs:~w~n", [
%         MegaSecs2 - MegaSecs,
%         Secs2 - Secs,
%         MicroSecs2 - MicroSecs
%     ]),

%     Ret.

% my_date_string() ->
%     {Year,Month,Day} = erlang:date(),
%     {Hour,Min,Sec} = erlang:time(),
%     io:format(
%         "Today is ~w/~w/~w ~w:~w:~w~n",
%         [Year, Month, Day, Hour, Min, Sec]).
