/* using default substitutions */
SELECT
  nation.n_name AS nation,
  YEAR(TO_DATE(orders.o_orderdate)) AS o_year,
  SUM(
    lineitem.l_extendedprice * (
      1 - lineitem.l_discount
    ) - partsupp.ps_supplycost * lineitem.l_quantity
  ) AS sum_profit
FROM part AS part
JOIN lineitem AS lineitem
  ON lineitem.l_partkey = part.p_partkey
JOIN orders AS orders
  ON lineitem.l_orderkey = orders.o_orderkey
JOIN partsupp AS partsupp
  ON lineitem.l_partkey = partsupp.ps_partkey AND lineitem.l_suppkey = partsupp.ps_suppkey
JOIN supplier AS supplier
  ON lineitem.l_suppkey = supplier.s_suppkey
JOIN nation AS nation
  ON nation.n_nationkey = supplier.s_nationkey
WHERE
  part.p_name LIKE '%green%'
GROUP BY
  nation.n_name,
  YEAR(TO_DATE(orders.o_orderdate))
ORDER BY
  nation,
  o_year DESC