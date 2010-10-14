-module(rabbitmq_pub).
-compile(export_all).

-include("rabbitmq_demo.hrl").
-include_lib("amqp_client/include/amqp_client.hrl").


send() -> send(["3"]).


send([Arg]) ->
    Connection = amqp_connection:start_network(#amqp_params{host = ?DEMO_HOST}),
    Channel = amqp_connection:open_channel(Connection),

    Routing = <<"NDPAR.ERLANG.ERLANG">>,
    Payload = <<"Hello from Erlang!">>,

    N = list_to_integer(Arg),
    for(1, N, fun() -> basic_publish(Channel, ?DEMO_EXCHANGE, Routing, Payload) end),

    amqp_channel:close(Channel),
    amqp_connection:close(Connection).


basic_publish(Channel, Exchange, Routing, Payload) ->
    Publish = #'basic.publish'{exchange = Exchange, routing_key = Routing},
    Message = #amqp_msg{payload = Payload},
    amqp_channel:cast(Channel, Publish, Message).


for(N, N, F) -> F();
for(I, N, F) -> F(), for(I+1, N, F).

