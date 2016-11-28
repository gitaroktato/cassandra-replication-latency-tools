#!/usr/bin/python-pip
import sys
from cassandra.cluster import Cluster
from cassandra.auth import PlainTextAuthProvider
from cassandra.policies import DCAwareRoundRobinPolicy

from time import time

# Parsing args
hostname = sys.argv[1]
username = sys.argv[2]
password = sys.argv[3]

# Logging in
auth_provider = PlainTextAuthProvider(username=username, password=password)
cluster = Cluster([hostname],
    auth_provider=auth_provider,
    load_balancing_policy=DCAwareRoundRobinPolicy(local_dc='AWS-AP-NORTHEAST'))
session = cluster.connect('replicated')

while True:
    result = []
    while len(result) <= 0:
        resultset = session.execute("""
        SELECT id, toUnixTimestamp(insertion_date) AS insertion_date, toUnixTimestamp(now()) AS now, some_data, WRITETIME (some_data) FROM replicated.test;
        """)
        result = resultset.current_rows
    # Got results
    print "Lantency for query: %d" % (result[0].now - result[0].insertion_date)
    session.execute("""
    UPDATE replicated.test_count
         SET response_counter = response_counter + 1
         WHERE id = {}
    """.format(result[0].id))
    # Waiting for next round
    print 'Waiting for next round'
    while len(result) > 0:
        resultset = session.execute("""
        SELECT id, toUnixTimestamp(insertion_date) AS insertion_date, toUnixTimestamp(now()) AS now, some_data, WRITETIME (some_data) FROM replicated.test;
        """)
        result = resultset.current_rows
