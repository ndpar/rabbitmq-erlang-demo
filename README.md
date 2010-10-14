## Building RabbitMQ Erlang client

    $ mkdir ~/rabbitmq-master
    $ cd ~/rabbitmq-master
    $ git clone git://github.com/rabbitmq/rabbitmq-server.git
    $ git clone git://github.com/rabbitmq/rabbitmq-codegen.git
    $ git clone git://github.com/rabbitmq/rabbitmq-erlang-client.git
    $ cd rabbitmq-erlang-client
    $ make

## Building demo

    $ cd ~/rabbitmq-erlang-demo
    $ vi src/rabbitmq_demo.hrl
    $ export RABBITMQ_HOME=~/rabbitmq-master
    $ make

## Starting subscriber

    $ cd ~/rabbitmq-erlang-demo/ebin
    $ ./sub.sh

## Publish messages

    $ cd ~/rabbitmq-erlang-demo/ebin
    $ ./pub.sh 10

## Links

[Official guide](http://www.rabbitmq.com/erlang-client-user-guide.html)

