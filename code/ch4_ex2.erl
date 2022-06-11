%% ---
%%  Excerpted from "Programming Erlang, Second Edition",
%%  published by The Pragmatic Bookshelf.
%%  Copyrights apply to this code. It may not be used to create training material, 
%%  courses, books, articles, and the like. Contact us if you are in doubt.
%%  We make no guarantees that this code is fit for any purpose. 
%%  Visit http://www.pragmaticprogrammer.com/titles/jaerlang2 for more book information.
%%---
-module(ch4_ex2).
-export([
    my_tuple_to_list/1
]).

my_tuple_to_list({}) -> [];
my_tuple_to_list(T) ->
    [element(N, T) || N <- lists:seq(1, size(T))].
