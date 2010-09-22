-module(rabbitmq_pub).
-compile(export_all).

-include_lib("amqp_client/include/amqp_client.hrl").

send(Args) ->
    Connection = amqp_connection:start_network(#amqp_params{host = "lab.ndpar.com"}),
    Channel = amqp_connection:open_channel(Connection),
    Exchange = <<"myExchange">>,
    Routing = <<"myRoutingKey">>,
    Payload = <<"Hello from Erlang!">>,

    statistics(runtime),
    statistics(wall_clock),

    N = list_to_integer(hd(Args)),
    for(1, N, fun() -> basic_publish(Channel, Exchange, Routing, Payload) end),

    amqp_channel:close(Channel),
    amqp_connection:close(Connection),

    {_, Time1} = statistics(runtime),
    {_, Time2} = statistics(wall_clock),
    io:format("Send time=~p (~p) nanoseconds~n", [Time1 / N, Time2 / N]).


basic_publish(Channel, Exchange, Routing, Payload) -> 
    Publish = #'basic.publish'{exchange = Exchange, routing_key = Routing},
    Message = #amqp_msg{payload = Payload},
    amqp_channel:cast(Channel, Publish, Message).


for(N, N, F) -> F();
for(I, N, F) -> F(), for(I+1, N, F).

