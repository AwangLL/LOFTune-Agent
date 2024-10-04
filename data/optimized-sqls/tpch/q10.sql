/* using default substitutions */
SELECT
  customer.c_custkey AS c_custkey,
  customer.c_name AS c_name,
  SUM(lineitem.l_extendedprice * (
    1 - lineitem.l_discount
  )) AS revenue,
  customer.c_acctbal AS c_acctbal,
  nation.n_name AS n_name,
  customer.c_address AS c_address,
  customer.c_phone AS c_phone,
  customer.c_comment AS c_comment
FROM customer AS customer
JOIN nation AS nation
  ON customer.c_nationkey = nation.n_nationkey
JOIN orders AS orders
  ON customer.c_custkey = orders.o_custkey
  AND orders.o_orderdate < CAST('1994-01-01' AS DATE)
  AND orders.o_orderdate >= CAST('1993-10-01' AS DATE)
JOIN lineitem AS lineitem
  ON lineitem.l_orderkey = orders.o_orderkey AND lineitem.l_returnflag = 'R'
GROUP BY
  customer.c_custkey,
  customer.c_name,
  customer.c_acctbal,
  customer.c_phone,
  nation.n_name,
  customer.c_address,
  customer.c_comment
ORDER BY
  revenue DESC
LIMIT 20