-module(efacegraph_http).

-export([send_request/1, send_request/3, form_encoded_to_plist/1,
         plist_to_form_encoded/1]).

send_request(Url) ->
  send_request(Url, [], []).

send_request(Url, Headers, Options) when is_list(Url) ->
  send_request(list_to_binary(Url), Headers, Options);
send_request(Url, Headers, Options) when is_binary(Url) ->
  case hackney:request(get, Url, Headers, <<>>, Options) of
    {ok, Status, RespHeaders, Client} ->
      check_http_resp(Status, RespHeaders, Client);
    Other ->
      io:format("HTTP Execution Error: ~p~n", [Other]),
      error(badarg)
  end.

check_http_resp(404, _Headers, Client) ->
  {ok, Body} = hackney:body(Client),
  io:format("HTTP 404 Not Found Error: ~s~n", [Body]),
  throw({not_authorized, jiffy:decode(Body)});
check_http_resp(403, _Headers, Client) ->
  {ok, Body} = hackney:body(Client),
  io:format("HTTP 403 Forbidden Error: ~s~n", [Body]),
  throw({forbidden, jiffy:decode(Body)});
check_http_resp(Status, _Headers, Client) when Status > 399 ->
  {ok, Body} = hackney:body(Client),
  io:format("HTTP Error: ~s~n", [Body]),
  throw({unknown_error, jiffy:decode(Body)});
check_http_resp(Status, Headers, _Client) when Status =< 399, Status > 200 ->
  %% hackney redirect throws up on FB CDN URLs.  Create our own redirect here.
  {_, Redirect} = lists:keyfind(<<"Location">>, 1, Headers),
  send_request(Redirect);
check_http_resp(Status, _Headers, Client) when Status =< 200 ->
  {ok, Body} = hackney:body(Client),
  Body.  % May or may not be JSON

form_encoded_to_plist(Encoded) ->
  Attributes = string:tokens(binary_to_list(Encoded), "&"),
  lists:map(fun(Attr) ->
              [Field, Value] = string:tokens(Attr, "="),
              {Field, Value}
            end, Attributes).

plist_to_form_encoded(Params) ->
  join("&", [join("=", [K, V]) || {K, V} <- Params]).

join(Sep, Xs) ->
  lists:concat(intersperse(Sep, Xs)).

intersperse(_, []) -> [];
intersperse(_, [X]) -> [X];
intersperse(Sep, [X|Xs]) ->
  [X, Sep|intersperse(Sep, Xs)].