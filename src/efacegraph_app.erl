-module(efacegraph_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
  % [ensure_started(X) || X <- [crypto, public_key, asn1, ssl, idna, hackney]].
  application:ensure_all_started(efacegraph),
  efacegraph_sup:start_link().

stop(_State) ->
  ok.
