truncate replicated.test;
insert into replicated.test (id, insertion_date, some_data) values (uuid(), now(), 'one');
