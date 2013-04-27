-module(rabbitmq_sub).

-export([start/0, stop/0]).

-include("../include/rabbitmq_demo.hrl").
-include_lib("amqp_client/include/amqp_client.hrl").

-define(DEMO_QUEUE, <<"ndpar.erlang.client">>).
-define(DEMO_BINDING_KEY, <<"NDPAR.#">>).


start() ->
    register(?MODULE, spawn(fun subscribe/0)).


subscribe() ->
    {ok, Connection} = amqp_connection:start(#amqp_params_network{host = ?DEMO_HOST}),
    {ok, Channel} = amqp_connection:open_channel(Connection),

    %Exchange = #'exchange.declare'{exchange = ?DEMO_EXCHANGE, type = <<"topic">>},
    %amqp_channel:call(Channel, Exchange),

    Queue = #'queue.declare'{queue = ?DEMO_QUEUE, auto_delete = true},
    amqp_channel:call(Channel, Queue),

    Binding = #'queue.bind'{queue = ?DEMO_QUEUE, exchange = ?DEMO_EXCHANGE, routing_key = ?DEMO_BINDING_KEY},
    amqp_channel:call(Channel, Binding),

    Sub = #'basic.consume'{queue = ?DEMO_QUEUE, no_ack = true},
    amqp_channel:subscribe(Channel, Sub, self()),

    loop(Connection, Channel).


loop(Connection, Channel) ->
    receive
        #'basic.consume_ok'{} ->
            loop(Connection, Channel);
        #'basic.cancel_ok'{} ->
            amqp_channel:close(Channel),
            amqp_connection:close(Connection),
            ok;
        {#'basic.deliver'{}, Message} ->
            spawn(fun() -> handle(Message) end),
            loop(Connection, Channel)
    end.


handle(Message) ->
    {amqp_msg, _Props, Payload} = Message,
    io:format("Received message: ~p~n", [binary_to_list(Payload)]).


stop() ->
    ?MODULE ! #'basic.cancel_ok'{},
    ok.
