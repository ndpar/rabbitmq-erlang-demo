#!/bin/sh

export ERL_LIBS=$RABBITMQ_HOME/rabbitmq-erlang-client/dist

erl -noshell -s rabbitmq_test main -s init stop

