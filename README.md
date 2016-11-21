# Determining network interface ID in bridged network

```
ln -s  /var/run/docker/netns /var/run/netns
ip netns list
ip netns exec 63739904f29c ip a
```

# Adding delays to this network
```
docker exec awsnode1 ip a | grep -B3 1.1.1.
ip link
tc qdisc add dev veth96e4f85 root netem delay 250ms
tc qdisc show
```
alias docker-gc='docker ps -aq | xargs docker rm -f'
