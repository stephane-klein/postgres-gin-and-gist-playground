# POC PostgreSQL GIN GIST Indexes

Root issue context (in french): https://github.com/stephane-klein/backlog/issues/316

Resources:

- [GIN Indexes](https://www.postgresql.org/docs/15/gin.html)
- [GIN Index has O(N^2) complexity for array overlap operator?](https://stackoverflow.com/a/70852000/261061)
- [btree_gist — GiST operator classes with B-tree behavior](https://www.postgresql.org/docs/16/btree-gist.html)
- [intarray — manipulate arrays of integers](https://www.postgresql.org/docs/16/intarray.html)
- French documentation [Indexation avancée](https://public.dalibo.com/exports/formation/manuels/modules/j5/j5.handout.html) by https://www.dalibo.com/


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
postgres@127:postgres> EXPLAIN ANALYZE SELECT * FROM public.users_gin WHERE ARRAY[2, 10] && space_ids;
+-----------------------------------------------------------------------------------------------------+
| QUERY PLAN                                                                                          |
|-----------------------------------------------------------------------------------------------------|
| Seq Scan on users_gin  (cost=0.00..20.62 rows=8 width=68) (actual time=0.015..0.019 rows=4 loops=1) |
|   Filter: ('{2,10}'::integer[] && space_ids)                                                        |
|   Rows Removed by Filter: 1                                                                         |
| Planning Time: 0.094 ms                                                                             |
| Execution Time: 0.033 ms                                                                            |
+-----------------------------------------------------------------------------------------------------+
EXPLAIN 5
Time: 0.009s
postgres@127:postgres> EXPLAIN ANALYZE SELECT * FROM public.users_gin WHERE ARRAY[2, 10] && space_ids;
+-----------------------------------------------------------------------------------------------------+
| QUERY PLAN                                                                                          |
|-----------------------------------------------------------------------------------------------------|
| Seq Scan on users_gin  (cost=0.00..20.62 rows=8 width=68) (actual time=0.013..0.016 rows=4 loops=1) |
|   Filter: ('{2,10}'::integer[] && space_ids)                                                        |
|   Rows Removed by Filter: 1                                                                         |
| Planning Time: 0.127 ms                                                                             |
| Execution Time: 0.029 ms                                                                            |
+-----------------------------------------------------------------------------------------------------+
EXPLAIN 5
Time: 0.008s
```
