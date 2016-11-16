CREATE KEYSPACE replicated WITH REPLICATION = { 'class' : 'NetworkTopologyStrategy', 'epam-by1' : 1, 'aws-ap-northeast' : 1 };
CREATE TABLE replicated.test (
  id uuid,
  insertion_date timeuuid,
  some_data varchar,
  PRIMARY KEY (id));
insert into replicated.test (id, insertion_date, some_data) values (uuid(), now(), 'one');
select id, some_data, WRITETIME (some_data) from replicated.test;
