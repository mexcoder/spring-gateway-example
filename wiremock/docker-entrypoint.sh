#!/usr/bin/env sh
#based on https://github.com/activatedgeek/docker-consul/blob/master/scripts/docker-entrypoint.sh byb Sanyam Kapoor

##
# external inputs with reasonable defaults
#
DATACENTER=${DATACENTER:-consul-dc}
LOG_LEVEL=${LOG_LEVEL:-INFO}
NETWORK_INTERFACE=${NETWORK_INTERFACE:-eth0}
CONFIG_DIR=${CONSUL_CONFIG_DIR:-"/etc/consul"}
CONFIG_FILE="$CONFIG_DIR/agent.json"
SERVICE_NAME=${CONSUL_SERVICE_NAME:-$(hostname)}
SERVICE_PORT=${CONSUL_SERVICE_PORT:-8080}


NETWORK_BIND_ADDR=$(ifconfig "$NETWORK_INTERFACE"| awk '/inet addr/{print substr($2,6)}')
# either use the default network address or externally provided
BIND_ADDR=${BIND_ADDR:-$NETWORK_BIND_ADDR}
HOSTNAME=$(hostname)

SERVICE_ADDRES=${SERVICE_ADDRES:-$BIND_ADDR}

# must be server or agent
MODE="agent"

# needs a FQDN or reachable IP address (can be empty for first node)
JOIN_ADDR=${CONSUL_JOIN_ADDR:-consul}

# setup consul agent config
AGENT_CONFIG=$(cat <<EOA
{
  "node_name": "$HOSTNAME",
  "datacenter": "$DATACENTER",
  "data_dir": "/var/consul/agent",
  "log_level": "$LOG_LEVEL",
  "bind_addr": "$BIND_ADDR",
  "retry_join": ["$JOIN_ADDR"],
  "service": {
    "name": "$SERVICE_NAME",
    "tags": ["wiremock"],
    "port": $SERVICE_PORT,
    "address": "$SERVICE_ADDRES"
  }
}
EOA
)

if [ ! -f "$CONFIG_FILE" ]; then
  # create config dir if not exists
  mkdir -p $CONFIG_DIR
  echo "$AGENT_CONFIG" > $CONFIG_FILE
fi

consul agent -config-file=$CONFIG_FILE &

# chain to the wiremock entrypoint

exec /wiremock-entrypoint.sh $*