efacegraph
==============

Description:
--------------

efacegraph was developed with the intent to be an Erlang client to Facebook
Graph API.

It is based loosely on [erlFBGraph](https://github.com/ejbraga/erlFBGraph),
which is not longer compatible with current releases of Erlang.  erlFBGraph was
in turn based on
[erlang_facebook](http://github.com/ngerakines/erlang_facebook).

It server-side responsibilities of OAuth authentication once a auth code has,
been received by the redirect process.  It also supports getting resource
details by ID, and I've started implementation of API edges in the user module.


Dependencies:
---------------

This module requires rebar as the build tool, jiffy to parse JSON objects and
hackney as the HTTP client.

TODO:
----
* Tests
* Docs
* Release config
* Expand edge support

Acknowledgements:
---------------

Thanks to [ejbraga](https://github.com/ejbraga) and
[ngerakines](http://github.com/ngerakines) for the development of
[erlFBGraph](http://github.com/ejbraga/erlFBGraph) and
[erlang_facebook](http://github.com/ngerakines/erlang_facebook), respectively.
