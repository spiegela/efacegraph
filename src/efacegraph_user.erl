-module(efacegraph_user).

-include_lib("efacegraph.hrl").

%% PUBLIC API

-export([picture/1, picture/2]).

picture(ID) ->
  picture(ID, []).

picture(ID, Options) ->
  Url = build_user_edge_url(ID, "picture", Options),
        efacegraph_http:send_request(Url).

build_user_edge_url(ID, Edge, Options) when is_binary(ID) ->
  build_user_edge_url(binary_to_list(ID), Edge, Options);
build_user_edge_url(ID, Edge, []) ->
  lists:concat([?GRAPH_URL, "/", ID, "/", Edge]);
build_user_edge_url(ID, Edge, Options) ->
  lists:concat([?GRAPH_URL, "/", ID, "/", Edge, "?",
                efacegraph_http:plist_to_form_encoded(Options)]).