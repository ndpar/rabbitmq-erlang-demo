AMQP_CLIENT=amqp_client
RABBITMQ_COMMON=rabbit_common

RABBITMQ_CLIENT_HOME=~/projects/rabbit/rabbitmq-erlang-client
RABBITMQ_CLIENT_DIST=$(RABBITMQ_CLIENT_HOME)/dist

SOURCE_DIR=src
INCLUDE_DIR=include
EBIN_DIR=ebin
DEPS_DIR=deps

INCLUDES=$(wildcard $(INCLUDE_DIR)/*.hrl)
SOURCES=$(wildcard $(SOURCE_DIR)/*.erl)
TARGETS=$(patsubst $(SOURCE_DIR)/%.erl, $(EBIN_DIR)/%.beam, $(SOURCES))

DEPS=$(DEPS_DIR)/$(AMQP_CLIENT) $(DEPS_DIR)/$(RABBITMQ_COMMON)
LIBS_PATH=$(DEPS_DIR)

ERLC_OPTS=-I $(INCLUDE_DIR) -pa $(EBIN_DIR) -o $(EBIN_DIR) -Wall -v +debug_info


all: compile

compile: $(TARGETS)

clean:
	rm -f $(EBIN_DIR)/*.beam
	rm -f erl_crash.dump
	rm -rf $(DEPS_DIR)

###############################################################################
## Internal Targets
###############################################################################

$(EBIN_DIR):
	mkdir -p $@

$(EBIN_DIR)/%.beam: $(SOURCE_DIR)/%.erl $(INCLUDES) $(DEPS) | $(EBIN_DIR)
	ERL_LIBS=$(LIBS_PATH) erlc $(ERLC_OPTS) $<

$(DEPS_DIR):
	mkdir -p $@

$(DEPS_DIR)/$(AMQP_CLIENT): $(RABBITMQ_CLIENT_DIST) | $(DEPS_DIR)
	rm -rf $@
	unzip -q -o $(RABBITMQ_CLIENT_DIST)/$(AMQP_CLIENT)*.ez -d $(DEPS_DIR)
	mv $(DEPS_DIR)/$(AMQP_CLIENT)* $@

$(DEPS_DIR)/$(RABBITMQ_COMMON): $(RABBITMQ_CLIENT_DIST) | $(DEPS_DIR)
	rm -rf $@
	unzip -q -o $(RABBITMQ_CLIENT_DIST)/$(RABBITMQ_COMMON)*.ez -d $(DEPS_DIR)
	mv $(DEPS_DIR)/$(RABBITMQ_COMMON)* $@
