#!/bin/sh
#
# Usage: ./pub.sh "NDPAR.ERLANG.TEST" "Hello World"
#
ERL_LIBS=deps erl -pa ebin -noshell -run rabbitmq_pub send $1 $2 -s init stop
