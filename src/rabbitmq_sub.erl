-module(rabbitmq_sub).

-export([start/0, subscribe/0, stop/0]).

-include("rabbitmq_demo.hrl").
-include_lib("amqp_client/include/amqp_client.hrl").


start() ->
    register(?MODULE, spawn(fun subscribe/0)).


subscribe() ->
    Connection = amqp_connection:start_network(#amqp_params{host = ?DEMO_HOST}),
    Channel = amqp_connection:open_channel(Connection),

    Exchange = #'exchange.declare'{exchange = ?DEMO_EXCHANGE, type = ?DEMO_EXCHANGE_TYPE},
    #'exchange.declare_ok'{} = amqp_channel:call(Channel, Exchange),

    Queue = #'queue.declare'{queue = ?DEMO_QUEUE},
    #'queue.declare_ok'{} = amqp_channel:call(Channel, Queue),

    Binding = #'queue.bind'{queue = ?DEMO_QUEUE, exchange = ?DEMO_EXCHANGE, routing_key = ?DEMO_BINDING_KEY},
    #'queue.bind_ok'{} = amqp_channel:call(Channel, Binding),

    Sub = #'basic.consume'{queue = ?DEMO_QUEUE, no_ack = true},
    #'basic.consume_ok'{consumer_tag = _Tag} = amqp_channel:subscribe(Channel, Sub, self()),

    loop(Channel),

    amqp_channel:close(Channel),
    amqp_connection:close(Connection),
    ok.


loop(Channel) ->
    receive
        #'basic.consume_ok'{} -> loop(Channel);
        #'basic.cancel_ok'{} -> ok;
        {#'basic.deliver'{delivery_tag = _Tag}, Message} ->
            spawn(fun() -> handle(Message) end),
            loop(Channel)
    end.


handle(Message) ->
    {amqp_msg, _Props, Payload} = Message,
    io:format("Received message: ~p~n", [binary_to_list(Payload)]).


stop() ->
    ?MODULE ! #'basic.cancel_ok'{},
    ok.

