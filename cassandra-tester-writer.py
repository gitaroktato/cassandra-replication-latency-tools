#!/usr/bin/python-pip
from cassandra.cluster import Cluster
from time import time

cluster = Cluster()
session = cluster.connect('replicated')

while True:
        session.execute("""
        insert into replicated.test (id, insertion_date, some_data) values (uuid(), now(), 'dummy');
        """)
        table_size = 1

        while table_size > 0:
            rs = session.execute ("""
            select count (*) as count from replicated.test
            """)
            table_size = rs[0].count
