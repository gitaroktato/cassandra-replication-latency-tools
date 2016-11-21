#!/bin/bash


# docker run --name node2 -d --link node1:cassandra cassandra:3.0.8
# iptables -tnat -A DOCKER -p tcp --dport 9042 -j DNAT --to-destination 172.17.0.2:9042
# docker run -t --rm -v /c/Users/Oresztesz_Margaritis/.docker/machine/certs:/etc/ssl/docker gaiaadm/pumba pumba --tls --host https://192.168.99.100:2376 netem --duration 1m delay

# Install brctl
# sudo curl -Lo /var/lib/boot2docker/bridge-utils.tcz  ftp://ftp.nl.netbsd.org/vol/2/metalab/distributions/tinycorelinux/4.x/x86_64/tcz/net-bridging-3.0.21-tinycore64.tcz


# Network setup
docker network create --subnet=1.1.1.0/24 wan
docker network create --subnet=192.168.1.0/24 internal-by1
docker network create --subnet=192.168.2.0/24 internal-aws

# Just getting rid of all iptalbes rules.
sudo iptables -F

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
      --net=$NETWORK_INTERFACE \
      --memory="1500m" \
      --ip=$INTERNAL_IP \
      -d cassandra:3.0.8

    docker network connect --ip=$EXTERNAL_IP wan $NAME

    docker exec $NAME /bin/bash -c 'echo listen_on_broadcast_address: true >> /etc/cassandra/cassandra.yaml'
    docker exec $NAME /bin/bash -c 'echo prefer_local=true >> /etc/cassandra/cassandra-rackdc.properties'
    docker exec $NAME nodetool stopdaemon
    # docker start $NAME
}

createNode 'by1node1' 'epam-by1' 'internal-by1' '192.168.1.10' '1.1.1.10' '1.1.1.10'
createNode 'by1node2' 'epam-by1' 'internal-by1' '192.168.1.11' '1.1.1.11' '1.1.1.10'
createNode 'by1node3' 'epam-by1' 'internal-by1' '192.168.1.12' '1.1.1.12' '1.1.1.10'
#
createNode 'awsnode1' 'aws-ap-northeast' 'internal-aws' '192.168.2.10' '1.1.1.20' '1.1.1.10'
createNode 'awsnode2' 'aws-ap-northeast' 'internal-aws' '192.168.2.11' '1.1.1.21' '1.1.1.20'
createNode 'awsnode3' 'aws-ap-northeast' 'internal-aws' '192.168.2.12' '1.1.1.22' '1.1.1.20'

#
# docker run --name by1node1 \
#   -e "CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch" \
#   -e "CASSANDRA_DC=epam-by1" \
#   -e "CASSANDRA_RACK=rack1" \
#   -e "CASSANDRA_SEEDS=1.1.1.10" \
#   -e "CASSANDRA_LISTEN_ADDRESS=192.168.1.10" \
#   -e "CASSANDRA_BROADCAST_ADDRESS=1.1.1.10" \
#   --net=internal-by1 \
#   --ip=192.168.1.10 \
#   -d -p 9042:9042 cassandra:3.0.8
#
# docker network connect --ip=1.1.1.10 wan by1node1
#
# docker exec by1node1 /bin/bash -c 'echo listen_on_broadcast_address: true >> /etc/cassandra/cassandra.yaml'
# docker exec by1node1 /bin/bash -c 'echo prefer_local=true >> /etc/cassandra/cassandra-rackdc.properties'
# docker exec by1node1 nodetool stopdaemon
# docker start by1node1
#
# docker run --name awsnode1 \
#   -e "CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch" \
#   -e "CASSANDRA_DC=aws-ap-northeast" \
#   -e "CASSANDRA_RACK=rack1" \
#   -e "CASSANDRA_LISTEN_ADDRESS=192.168.2.10" \
#   -e "CASSANDRA_BROADCAST_ADDRESS=1.1.1.20" \
#   -e "CASSANDRA_SEEDS=1.1.1.10" \
#   --net=internal-aws \
#   --ip=192.168.2.10 \
#   -d -p 9045:9042 cassandra:3.0.8
#
# docker network connect --ip=1.1.1.20 wan awsnode1
#
# docker exec awsnode1 /bin/bash -c 'echo listen_on_broadcast_address: true >> /etc/cassandra/cassandra.yaml'
# docker exec awsnode1 /bin/bash -c 'echo prefer_local=true >> /etc/cassandra/cassandra-rackdc.properties'
# docker exec awsnode1 nodetool stopdaemon
# docker start awsnode1
#
#
# docker run --name by1node2 \
#   -e "CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch" \
#   -e "CASSANDRA_DC=epam-by1" \
#   -e "CASSANDRA_RACK=rack1" \
#   -e "CASSANDRA_SEEDS=1.1.1.10" \
#   -e "CASSANDRA_LISTEN_ADDRESS=192.168.1.11" \
#   -e "CASSANDRA_BROADCAST_ADDRESS=1.1.1.11" \
#   --net=internal-by1 \
#   --ip=192.168.1.11 \
#   -d -p 9043:9042 cassandra:3.0.8
#
# docker network connect --ip=1.1.1.11 wan by1node2
# docker exec by1node2 /bin/bash -c 'echo listen_on_broadcast_address: true >> /etc/cassandra/cassandra.yaml'
# docker exec by1node2 /bin/bash -c 'echo prefer_local=true >> /etc/cassandra/cassandra-rackdc.properties'
# docker exec by1node2 nodetool stopdaemon
# docker start by1node2
#
# docker run --name by1node3 \
#   -e "CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch" \
#   -e "CASSANDRA_DC=epam-by1" \
#   -e "CASSANDRA_RACK=rack1" \
#   -e "CASSANDRA_SEEDS=by1node1" \
#   --net=internal-by1
#   -d -p 9044:9042 cassandra:3.0.8
#
#
#
# docker run --name awsnode2 \
#   -e "CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch" \
#   -e "CASSANDRA_DC=aws-ap-northeast" \
#   -e "CASSANDRA_RACK=rack1" \
#   --link by1node1:cassandra \
#   -d -p9046:9042 cassandra:3.0.8
#
# docker run --name awsnode3 \
#   -e "CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch" \
#   -e "CASSANDRA_DC=aws-ap-northeast" \
#   -e "CASSANDRA_RACK=rack1" \
#   --link by1node1:cassandra \
#   -d -p9047:9042 cassandra:3.0.8
#
#
# # Install python drivers
# apt update
# apt install python-pip
# pip install cassandra-driver
#
# # Python test code
