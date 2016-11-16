#!/usr/bin/python-pip
from cassandra.cluster import Cluster
from time import time

cluster = Cluster()
session = cluster.connect('replicated')

while True:
    result = []
    while len(result) <= 0:
        resultset = session.execute("""
        select id, toUnixTimestamp(insertion_date) as insertion_date, toUnixTimestamp(now()) as now, some_data, WRITETIME (some_data) from replicated.test;
        """)
        result = resultset.current_rows


    print "Lantency for query: %d" % (result[0].now - result[0].insertion_date)
    session.execute("truncate replicated.test")
