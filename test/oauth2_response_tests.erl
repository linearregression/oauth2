%% ----------------------------------------------------------------------------
%%
%% oauth2: Erlang OAuth 2.0 implementation
%%
%% Copyright (c) 2012 KIVRA
%%
%% Permission is hereby granted, free of charge, to any person obtaining a
%% copy of this software and associated documentation files (the "Software"),
%% to deal in the Software without restriction, including without limitation
%% the rights to use, copy, modify, merge, publish, distribute, sublicense,
%% and/or sell copies of the Software, and to permit persons to whom the
%% Software is furnished to do so, subject to the following conditions:
%%
%% The above copyright notice and this permission notice shall be included in
%% all copies or substantial portions of the Software.
%%
%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
%% FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
%% DEALINGS IN THE SOFTWARE.
%%
%% ----------------------------------------------------------------------------

-module(oauth2_response_tests).

-include_lib("eunit/include/eunit.hrl").

-define(ACCESS,  <<"9bX9iFUOsXbM12OOjfDW175IXXOELp6K">>).
-define(REFRESH, <<"JVs3ZFQJBIdduJdhhWOoAt2B3qEKcHEo">>).
-define(EXPIRY, 3600).
-define(SCOPE, <<"herp derp">>).

%%%===================================================================
%%% Test cases
%%%===================================================================

new_1_test_() ->
    {setup,
     fun() -> oauth2_response:new(?ACCESS) end,
     fun(_) -> ok end,
     fun(Response) ->
             [
              ?_assertEqual({ok, ?ACCESS}, oauth2_response:access_token(Response)),
              ?_assertMatch({error, not_set}, oauth2_response:expires_in(Response)),
              ?_assertMatch({error, not_set}, oauth2_response:scope(Response)),
              ?_assertMatch({error, not_set}, oauth2_response:refresh_token(Response))
             ]
     end}.

new_2_test_() ->
    {setup,
     fun() -> oauth2_response:new(?ACCESS, ?EXPIRY) end,
     fun(_) -> ok end,
     fun(Response) ->
             [
              ?_assertEqual({ok, ?ACCESS}, oauth2_response:access_token(Response)),
              ?_assertEqual({ok, ?EXPIRY}, oauth2_response:expires_in(Response)),
              ?_assertMatch({error, not_set}, oauth2_response:scope(Response)),
              ?_assertMatch({error, not_set}, oauth2_response:refresh_token(Response))
             ]
     end}.

new_3_test_() ->
    {setup,
     fun() -> oauth2_response:new(?ACCESS, ?EXPIRY, ?SCOPE) end,
     fun(_) -> ok end,
     fun(Response) ->
             [
              ?_assertEqual({ok, ?ACCESS}, oauth2_response:access_token(Response)),
              ?_assertEqual({ok, ?EXPIRY}, oauth2_response:expires_in(Response)),
              ?_assertEqual({ok, ?SCOPE}, oauth2_response:scope(Response)),
              ?_assertMatch({error, not_set}, oauth2_response:refresh_token(Response))
             ]
     end}.

new_4_test_() ->
    {setup,
     fun() -> oauth2_response:new(?ACCESS, ?EXPIRY, ?SCOPE, ?REFRESH) end,
     fun(_) -> ok end,
     fun(Response) ->
             [
              ?_assertEqual({ok, ?ACCESS}, oauth2_response:access_token(Response)),
              ?_assertEqual({ok, ?EXPIRY}, oauth2_response:expires_in(Response)),
              ?_assertEqual({ok, ?SCOPE}, oauth2_response:scope(Response)),
              ?_assertEqual({ok, ?REFRESH}, oauth2_response:refresh_token(Response))
             ]
     end}.

access_token_test() ->
    ?assertEqual({ok, ?REFRESH},
                 oauth2_response:access_token(
                   oauth2_response:access_token(
                     oauth2_response:new(?ACCESS),
                     ?REFRESH))).

expires_in_test() ->
    ?assertEqual({ok, ?EXPIRY},
                 oauth2_response:expires_in(
                   oauth2_response:expires_in(
                   oauth2_response:new(?ACCESS),
                     ?EXPIRY))).

scope_test() ->
    ?assertEqual({ok, ?SCOPE},
                 oauth2_response:scope(
                   oauth2_response:scope(
                     oauth2_response:new(?ACCESS),
                     ?SCOPE))).

refresh_token_test() ->
    ?assertEqual({ok, ?REFRESH},
                 oauth2_response:refresh_token(
                   oauth2_response:refresh_token(
                     oauth2_response:new(?ACCESS),
                     ?REFRESH))).

to_proplist_test() ->
    Response = oauth2_response:new(?ACCESS, ?EXPIRY, ?SCOPE, ?REFRESH),
    ?assertEqual([{<<"access_token">>, ?ACCESS},
                  {<<"expires_in">>, list_to_binary(integer_to_list(?EXPIRY))},
                  {<<"scope">>, ?SCOPE},
                  {<<"refresh_token">>, ?REFRESH},
                  {<<"token_type">>, <<"bearer">>}],
                 oauth2_response:to_proplist(Response)).