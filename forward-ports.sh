#!/bin/bash
# This forwards ports used in development so you can just work as it everything is
# running locally

ports="8000 3306 5400 8983 10001"
public_ports="8080"

echo "Forwaring ports (private: $ports, public: $public_ports), ^C to stop"
opts=""
for port in $ports
do
  opts="${opts} -L${port}:localhost:${port}"
done
for port in $public_ports
do
  opts="${opts} -L*:${port}:localhost:${port}"
done
boot2docker ssh $opts -N

