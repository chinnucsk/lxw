-module(lxw_my_controller, [Req, Session]).

-define(DEBUG(Arg, Input), error_logger:info_msg("~p~p:"++Arg++"\n\n", [?MODULE, ?LINE|Input])).

-export([hello/2, 
         before_/1,
         login/2,
         home/2,
         testjson/2,
         index/2]).
-include("lxw.hrl").
-default_action(index).

hello('GET',[]) ->
    ?DEBUG("hello Session=~p", [Session]),    
    {output,"Hello Word!!!"}.
testjson('GET', []) ->
    {json, [{name,"langxw"}]}.

before_("index") ->
    ok;
before_("testjson") ->
    ok;
before_("hello") ->
    ok;
before_("register") ->
    ok;
before_("login") ->
    ok;
    %{redirect, "index"};
before_(_Other) ->
    %%is_authorization()
    case mnesia:dirty_index_read(session, Session, sid) of
        [] -> {redirect, "index"};
        L when is_list(L) ->
            ok;
        _ -> {redirect, "index"}
    end.

login('GET', []) ->
    ?DEBUG("login Session=~p", [Session]),    
    case Req:query_param("username") of
        'undefined' ->
            {redirect, "index"};
        "" ->
            {redirect, "index"};
        Username ->
            mnesia:dirty_write(#session{user = Username, sid = Session}),
            {redirect, "home"}
    end.

index('GET', []) ->
    ?DEBUG("index Session=~p", [Session]),    
    {ok, []}.
home('GET', []) ->
    ?DEBUG("home Session=~p", [Session]),    
    {ok, []}.



