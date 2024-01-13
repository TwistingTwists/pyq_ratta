# local_ip=$(ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}' | head -n1)
local_ip="localhost"

export $(cat .env | xargs)
iex --sname pyq_ratta@$local_ip --cookie ratlobhai -S mix phx.server
