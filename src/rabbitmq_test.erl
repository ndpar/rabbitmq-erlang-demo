-module(rabbitmq_test).
-compile(export_all).

-include_lib("amqp_client/include/amqp_client.hrl").

main() ->
    Connection = amqp_connection:start_network(#amqp_params{host = "lab.ndpar.com"}),
    Channel = amqp_connection:open_channel(Connection),
    Exchange = <<"myExchange">>,
    Routing = <<"myRoutingKey">>,
    Payload = <<"Hello from Erlang!">>,

    ok = basic_publish(Channel, Exchange, Routing, Payload),

    amqp_channel:close(Channel),
    amqp_connection:close(Connection),
    ok.

basic_publish(Channel, Exchange, Routing, Payload) -> 
    Publish = #'basic.publish'{exchange = Exchange, routing_key = Routing},
    Message = #amqp_msg{payload = Payload},
    ok = amqp_channel:cast(Channel, Publish, Message),
    ok.

