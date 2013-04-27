## Build RabbitMQ Erlang client

    $ mkdir -p ~/projects/rabbit
    $ cd ~/projects/rabbit
    $ git clone git@github.com:rabbitmq/rabbitmq-codegen.git
    $ git clone git@github.com:rabbitmq/rabbitmq-server.git
    $ git clone git@github.com:rabbitmq/rabbitmq-erlang-client.git
    $ cd rabbitmq-erlang-client
    $ make

## Build demo

    $ make

## Subscribe to messages

    $ ./sub.sh

## Publish messages

    $ ./pub.sh "NDPAR.ERLANG.TEST" "Hello World"

## Unsubscribe

    > rabbitmq_sub:stop().

## Links

[Official guide](http://www.rabbitmq.com/erlang-client-user-guide.html)

