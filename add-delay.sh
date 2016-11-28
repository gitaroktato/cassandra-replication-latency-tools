#!/bin/bash
aws_nodes=(awsnode1 awsnode2 awsnode3)

for i in ${aws_nodes[@]}; do
        docker exec --privileged $i tc qdisc add dev eth1 root netem delay $1
done
