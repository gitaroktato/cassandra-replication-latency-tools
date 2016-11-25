#!/bin/bash
function getVirtualEthernetIdFromContainerId {
  CONTAINER=$1
  docker exec $CONTAINER ip a | grep -B3 1.1.1. | grep '@if' | sed -n 's/.*if\([0-9][0-9]*\).*/\1/p'
}

function getVirtualEthernetById {
  ip link | grep "^${1}:"
}

RESULT=$(getVirtualEthernetIdFromContainerId 'awsnode1')
getVirtualEthernetById $RESULT
