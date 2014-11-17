-module(efacegraph).

-include_lib("efacegraph.hrl").

%% PUBLIC API

-export([get_token/4, get_token_info/1, get_token_info/2, get_object_data/2]).

get_token(AppID, AppSecret, Redirect, Code) ->
  Url  = build_token_url(AppID, AppSecret, Redirect, Code),
  Resp = efacegraph_http:send_request(Url),
         efacegraph_http:form_encoded_to_plist(Resp).

get_token_info(Token) ->
  Resp = get_token_info(Token, Token),
         jiffy:decode(Resp).

get_token_info(InputToken, AccessToken) ->
  Url = build_debug_url(InputToken, AccessToken),
        efacegraph_http:send_request(Url).

get_object_data(ID, AccessToken) when is_binary(ID) ->
  get_object_data(binary_to_list(ID), AccessToken);
get_object_data(ID, AccessToken) ->
 Url  = build_object_URL(ID, AccessToken),
 Resp = efacegraph_http:send_request(Url),
        jiffy:decode(Resp).

build_token_url(AppID, AppSecret, Redirect, Code) ->
  lists:concat([?TOKEN_URL, "?client_id=", AppID, "&client_secret=", AppSecret,
                "&redirect_uri=", Redirect, "&code=", Code]).

build_object_URL(ID, Token) ->
  lists:concat([?GRAPH_URL, "/", ID, "?access_token=", Token]).

 build_debug_url(InputToken, AccessToken) ->
  lists:concat([?DEBUG_URL, "?access_token=", AccessToken,
                            "&input_token=", InputToken]).