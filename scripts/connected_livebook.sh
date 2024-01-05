#!/bin/sh

# Usage:
#
# Development:  ./connect-live.sh
# Production:   ./connect-live.sh prod

fly_app="my-app"
fly_cookie=$ERL_COOKIE
dev_app="pyq_ratta"
dev_cookie="ratlobhai"

# head -n1 is because you may have tailscale which returns one more IP.
local_ip=$(ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}' | head -n1)


export LIVEBOOK_HOME="notebooks"
export LIVEBOOK_DATA_PATH="notebooks"
export LIVEBOOK_PASSWORD="salunkhekaungli"

case "$1" in
  "prod")
    echo "[PROD] Starting Livebook..."
    fly_ip=$(fly ips private --app $fly_app | cut -f 3 | sed -n 2p)
    fly_node="$fly_app@$fly_ip"
    export LIVEBOOK_DEFAULT_RUNTIME="attached:$fly_node:$fly_cookie"
    export LIVEBOOK_NODE="livebook@127.0.0.1"
    export LIVEBOOK_DISTRIBUTION="name"
    export ERL_AFLAGS="-proto_dist inet6_tcp"
    ;;
  *)
    echo "[DEV] Starting Livebook..."
    dev_node="$dev_app@$local_ip"
    echo -e "dev_node: $dev_node \n"
    # export LIVEBOOK_DEFAULT_RUNTIME="attached:$dev_node:$dev_cookie"
    ;;
esac

livebook server