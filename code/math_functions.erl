%% ---
%%  Excerpted from "Programming Erlang, Second Edition",
%%  published by The Pragmatic Bookshelf.
%%  Copyrights apply to this code. It may not be used to create training material, 
%%  courses, books, articles, and the like. Contact us if you are in doubt.
%%  We make no guarantees that this code is fit for any purpose. 
%%  Visit http://www.pragmaticprogrammer.com/titles/jaerlang2 for more book information.
%%---
-module(math_functions).
-export([
    even/1,
    odd/1,
    filter/2,
    split_w_filter/1,
    split_w_acc/1
    ]).

even(N) -> N rem 2 =:= 0.
odd(N) -> N rem 2 =:= 1.

filter(F, L) ->
    [X || X <- L, F(X) =:= true].

split_w_filter(L) ->
    {filter(fun even/1, L), filter(fun odd/1, L)}.


split_w_acc(L) ->
    split_w_acc2(L, {[], []}).

split_w_acc2([], {Even, Odd}) -> {Even, Odd};
split_w_acc2([H|T], {Even, Odd}) ->
    X = even(H),
    case X of
        true -> split_w_acc2(T, {[H|Even], Odd});
        false -> split_w_acc2(T, {Even, [H|Odd]})
    end.
