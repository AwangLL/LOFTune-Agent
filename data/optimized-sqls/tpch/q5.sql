/* using default substitutions */
SELECT
  nation.n_name AS n_name,
  SUM(lineitem.l_extendedprice * (
    1 - lineitem.l_discount
  )) AS revenue
FROM customer AS customer
JOIN orders AS orders
  ON customer.c_custkey = orders.o_custkey
  AND orders.o_orderdate < CAST('1995-01-01' AS DATE)
  AND orders.o_orderdate >= CAST('1994-01-01' AS DATE)
JOIN supplier AS supplier
  ON customer.c_nationkey = supplier.s_nationkey
JOIN lineitem AS lineitem
  ON lineitem.l_orderkey = orders.o_orderkey AND lineitem.l_suppkey = supplier.s_suppkey
JOIN nation AS nation
  ON nation.n_nationkey = supplier.s_nationkey
JOIN region AS region
  ON nation.n_regionkey = region.r_regionkey AND region.r_name = 'ASIA'
GROUP BY
  nation.n_name
ORDER BY
  revenue DESC