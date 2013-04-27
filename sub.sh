#!/bin/sh

ERL_LIBS=deps erl -pa ebin -s rabbitmq_sub start
