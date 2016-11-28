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
When running on real servers, you have to set-up NTP sync between them, or you'll measurements won't be accurate. For example our [real severs](#running-tests-on-real-servers) show around **115 ms** latency without any NTP configuration.
![Stats before NTP sync](https://github.com/gitaroktato/cassandra-cluster-simulation/raw/master/images/latency_before_ntp_sync.png)
## Installing NTP
```
sudo yum install ntp
```

## Setting up common NTP server
```
# vi /etc/ntp.conf
```
**TBD**

## Checking the settings
```
# ntpstat
# ntpq -p
```

## Related links
[https://en.wikipedia.org/wiki/Network_Time_Protocol#Clock_synchronization_algorithm]
[http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/set-time.html]
[http://www.ntp.org/ntpfaq/NTP-a-faq.htm]

# Running tests in simulation
The scripts were tested with boot2docker on Windows.

**TBD**

## Setting up and starting containers
Use the `create-cluster.sh` bash script to setup your cluster with docker

## Adding delays to WAN network on AWS nodes
```
docker exec -ti --privileged awsnode1 tc qdisc add dev eth1 root netem delay 25ms
docker exec -ti --privileged awsnode1 tc qdisc show
```

## Checking cluster status
```
docker exec by1node1 nodetool status
```

## Destroying all containers
```
docker ps -qa | xargs docker rm -f
```

# How it works?
**TBD**
