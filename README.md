# What's this?
These scripts can be used to test replication latency in a multi-region Cassandra cluster

# Installation
## Installation of python drivers for Cassandra
To run the test scripts we have to execute the following commands
```
# apt update
# apt install python-pip
# pip install cassandra-driver
```
## Preparing the tables
To create the test tables, run the `create-test-tables.cql` on your cluster

## Running python clients on various parts of cluster
Start one writer in one local node, with the following parameters
```
$ python ./cassandra-tester-writer.py LOCAL_ADDRESS_OF_THE_NODE USERNAME PASSWORD NUMBER_OF_READERS
```
Start readers at the other end of the globe with the following parameters
```
$ python ./cassandra-tester-reader.py LOCAL_ADDRESS_OF_THE_NODE USERNAME PASSWORD
```
Output will show measured replication latency on each node

# Restarting the tests
Before restarting the tests, you need to truncate all the tables
```SQL
CONSISTENCY ALL
TRUNCATE replicated.test;
TRUNCATE replicated.test_count;
```

# Running tests on real servers
We have 3 nodes in Belarus and 3 nodes in Asia Pacific (Tokyo). The network characteristics between the two locations are the following
```
$ sudo iperf -c .... -u -t 60
------------------------------------------------------------
Client connecting to ...., UDP port 5001
Sending 1470 byte datagrams, IPG target: 11215.21 us (kalman adjust)
UDP buffer size:  208 KByte (default)
------------------------------------------------------------
[  3] local .... port 43529 connected with .... port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-60.0 sec  7.50 MBytes  1.05 Mbits/sec
[  3] Sent 5351 datagrams
[  3] Server Report:
[  3]  0.0-60.0 sec  7.41 MBytes  1.04 Mbits/sec   0.100 ms   66/ 5351 (1.2%)
```

```
$ sudo iperf -c ... -u -b 100m -t 60
------------------------------------------------------------
Client connecting to , UDP port 5001
Sending 1470 byte datagrams, IPG target: 117.60 us (kalman adjust)
UDP buffer size:  208 KByte (default)
------------------------------------------------------------
[  3] local ... port 55882 connected with ... port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-60.0 sec   715 MBytes   100 Mbits/sec
[  3] Sent 510205 datagrams
[  3] Server Report:
[  3]  0.0-60.0 sec   702 MBytes  98.1 Mbits/sec   0.040 ms 9805/510205 (1.9%)
[  3] 0.00-60.00 sec  10 datagrams received out-of-order
```

# NTP Sync
When running on real servers, you have to set-up NTP sync between them, or you'll measurements won't be accurate.
For example our [real severs](#Running tests on real servers) show around 110ms latency without any NTP configuration.
[images/latency_before_ntp_sync.png]

## Installing NTP
```
sudo yum install ntp
```

## Setting up common NTP server

## Checking the settings

## Related links
[https://en.wikipedia.org/wiki/Network_Time_Protocol#Clock_synchronization_algorithm]
[http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/set-time.html]

# Running in simulation
**TBD**
## Determining network interface ID in bridged network

```
ln -s  /var/run/docker/netns /var/run/netns
ip netns list
ip netns exec 63739904f29c ip a
```

## Adding delays to this network
```
docker exec awsnode1 ip a | grep -B3 1.1.1.
ip link
tc qdisc add dev veth96e4f85 root netem delay 250ms
tc qdisc show
```

## Useful alias command
```
alias docker-gc='docker ps -aq | xargs docker rm -f'
```

# How it works?
**TBD**
