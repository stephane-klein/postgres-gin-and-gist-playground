# POC PostgreSQL GIN Indexes

Resources:

- [GIN Indexes](https://www.postgresql.org/docs/15/gin.html)

```sh
$ docker compose up -d --wait
```

```
$ pgcli "postgres://postgres:password@127.0.0.1:5432/postgres"
postgres@127:postgres> \i playground.sql
postgres@127:postgres> select * from public.users;
+----+----------+-----------+
| id | username | space_ids |
|----+----------+-----------|
| 1  | user1    | [1, 2]    |
| 2  | user2    | [1, 2, 3] |
| 3  | user3    | [2, 3]    |
| 4  | user4    | [2]       |
| 5  | user5    | [1, 3]    |
+----+----------+-----------+
postgres@127:postgres> SELECT * FROM public.users WHERE ARRAY[2, 10] && space_ids;
+----+----------+-----------+
| id | username | space_ids |
|----+----------+-----------|
| 1  | user1    | [1, 2]    |
| 2  | user2    | [1, 2, 3] |
| 3  | user3    | [2, 3]    |
| 4  | user4    | [2]       |
+----+----------+-----------+
postgres@127:postgres> SET ENABLE_SEQSCAN TO OFF;
postgres@127:postgres> EXPLAIN ANALYZE SELECT * FROM public.users_gin WHERE ARRAY[2, 10] && space_ids;
+-------------------------------------------------------------------------------------------------------------------------+
| QUERY PLAN                                                                                                              |
|-------------------------------------------------------------------------------------------------------------------------|
| Bitmap Heap Scan on users_gin  (cost=17.27..27.43 rows=8 width=68) (actual time=0.021..0.023 rows=4 loops=1)            |
|   Recheck Cond: ('{2,10}'::integer[] && space_ids)                                                                      |
|   Heap Blocks: exact=1                                                                                                  |
|   ->  Bitmap Index Scan on space_ids_index  (cost=0.00..17.27 rows=8 width=0) (actual time=0.014..0.014 rows=4 loops=1) |
|         Index Cond: (space_ids && '{2,10}'::integer[])                                                                  |
| Planning Time: 0.113 ms                                                                                                 |
| Execution Time: 0.049 ms                                                                                                |
+-------------------------------------------------------------------------------------------------------------------------+
EXPLAIN 7
Time: 0.008s
```
