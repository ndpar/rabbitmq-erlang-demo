-module(rabbitmq_pub).

-export([send/1, send/2]).

-include("../include/rabbitmq_demo.hrl").
-include_lib("amqp_client/include/amqp_client.hrl").


send([RoutingKey | Message]) ->
    send(RoutingKey, string:join(Message, " ")).

send(RoutingKey, Message) ->
    {ok, Connection} = amqp_connection:start(#amqp_params_network{host = ?DEMO_HOST}),
    {ok, Channel} = amqp_connection:open_channel(Connection),

    Publish = #'basic.publish'{exchange = ?DEMO_EXCHANGE, routing_key = list_to_binary(RoutingKey)},
    amqp_channel:cast(Channel, Publish, #amqp_msg{payload = list_to_binary(Message)}),

    amqp_channel:close(Channel),
    amqp_connection:close(Connection),
    ok.
