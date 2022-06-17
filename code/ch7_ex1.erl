%% ---
%%  Excerpted from "Programming Erlang, Second Edition",
%%  published by The Pragmatic Bookshelf.
%%  Copyrights apply to this code. It may not be used to create training material, 
%%  courses, books, articles, and the like. Contact us if you are in doubt.
%%  We make no guarantees that this code is fit for any purpose. 
%%  Visit http://www.pragmaticprogrammer.com/titles/jaerlang2 for more book information.
%%---
-module(ch7_ex1).
-export([
    reverse_bin/1,
    chain/2,
    term_to_packet/1,
    packet_to_term/1
]).

reverse_bin(Bin) ->
    binary:list_to_bin(
    lists:reverse(
        binary:bin_to_list(Bin)
    )).


-spec chain(any(), [fun()]) -> any().
chain(Val, []) -> Val;
chain(Val, [H|T]) ->
    chain(H(Val), T).


-spec term_to_packet(any()) -> binary().
term_to_packet(Term) ->
    Bin = erlang:term_to_binary(Term),
    Size = erlang:byte_size(Bin),
    <<Size:4, Bin/binary>>.

-spec packet_to_term(binary()) -> any().
packet_to_term(Packet) ->
    <<_Size:4, Bin/binary>> = Packet,
    erlang:binary_to_term(Bin).
