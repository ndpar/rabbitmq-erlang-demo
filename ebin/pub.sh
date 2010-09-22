#!/bin/sh
#
# Usage: ./pub.sh 100
#
export ERL_LIBS=$RABBITMQ_HOME/rabbitmq-erlang-client/dist

erl -noshell -run rabbitmq_pub send $1 -s init stop

