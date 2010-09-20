#!/bin/sh

export ERL_LIBS=$RABBITMQ_HOME/rabbitmq-erlang-client/dist

erl -noshell -s rabbitmq_pub main -s init stop

