#!/bin/sh

export ERL_LIBS=$RABBITMQ_HOME/rabbitmq-erlang-client/dist

erl -s rabbitmq_sub start

