CREATE KEYSPACE replicated WITH REPLICATION = { 'class' : 'NetworkTopologyStrategy', 'epam-by1' : 2, 'AWS-AP-NORTHEAST' : 2 };
CREATE TABLE replicated.test (
  id uuid,
  insertion_date timeuuid,
  some_data varchar,
  desired_response_counter int,
  PRIMARY KEY (id));
CREATE TABLE replicated.test_count (
    id uuid,
    response_counter counter,
    PRIMARY KEY (id));
/*insert into replicated.test (id, insertion_date, some_data) values (uuid(), now(), 'one');
select id, some_data, WRITETIME (some_data) from replicated.test;*/
