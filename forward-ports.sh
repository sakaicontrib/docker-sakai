#!/bin/bash
# This forwards ports used in development so you can just work as it everything is
# running locally

if [ "$1" != "" ] ; then
  machine="$1"
else
  machine=$(docker-machine active 2>/dev/null)
  # If there's no machine active exit.
  if [ $? -ne 0 ] ; then
    echo "You need to supply a docker-machine host to use or set the active host"
    exit 1;
  fi
fi


ports="8000 3306 5400 8983 10001"
public_ports="8080"

echo "Forwaring ports (private: $ports, public: $public_ports) on $machine, ^C to stop"
opts=""
for port in $ports
do
  opts="${opts} -L${port}:localhost:${port}"
done
for port in $public_ports
do
  opts="${opts} -L*:${port}:localhost:${port}"
done
docker-machine ssh "$machine" $opts -N

