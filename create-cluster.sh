#!/bin/bash

# Network setup
docker network create --subnet=1.1.1.0/24 wan
docker network create --subnet=192.168.1.0/24 internal-by1
docker network create --subnet=192.168.2.0/24 internal-aws

# Just getting rid of all iptalbes rules.
function dropFiltersInIPTables {
    docker run --net=host --privileged --rm alpine \
      /bin/sh -c 'apk update; apk add iptables; iptables -F'
}

function createNode {
    NAME=$1
    DATACENTER=$2
    NETWORK_INTERFACE=$3
    INTERNAL_IP=$4
    EXTERNAL_IP=$5
    SEED_NODES=$6

    docker run --name $NAME \
      -e "CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch" \
      -e "CASSANDRA_DC=$DATACENTER" \
      -e "CASSANDRA_RACK=rack1" \
      -e "CASSANDRA_SEEDS=$SEED_NODES" \
      -e "CASSANDRA_LISTEN_ADDRESS=$INTERNAL_IP" \
      -e "CASSANDRA_BROADCAST_ADDRESS=$EXTERNAL_IP" \
      -e "MAX_HEAP_SIZE=512M" \
      -e "HEAP_NEWSIZE=128M" \
      --net=$NETWORK_INTERFACE \
      --ip=$INTERNAL_IP \
      -d cassandra:3.0.8

    docker network connect --ip=$EXTERNAL_IP wan $NAME

    docker exec $NAME /bin/bash -c 'echo listen_on_broadcast_address: true >> /etc/cassandra/cassandra.yaml'
    docker exec $NAME /bin/bash -c 'echo prefer_local=true >> /etc/cassandra/cassandra-rackdc.properties'
    docker exec $NAME nodetool stopdaemon
    docker start $NAME
}

dropFiltersInIPTables

createNode 'by1node1' 'epam-by1' 'internal-by1' '192.168.1.10' '1.1.1.10' '1.1.1.10'
createNode 'by1node2' 'epam-by1' 'internal-by1' '192.168.1.11' '1.1.1.11' '1.1.1.10'
createNode 'by1node3' 'epam-by1' 'internal-by1' '192.168.1.12' '1.1.1.12' '1.1.1.10'
#
createNode 'awsnode1' 'AWS-AP-NORTHEAST' 'internal-aws' '192.168.2.10' '1.1.1.20' '1.1.1.10'
createNode 'awsnode2' 'AWS-AP-NORTHEAST' 'internal-aws' '192.168.2.11' '1.1.1.21' '1.1.1.20'
createNode 'awsnode3' 'AWS-AP-NORTHEAST' 'internal-aws' '192.168.2.12' '1.1.1.22' '1.1.1.20'
