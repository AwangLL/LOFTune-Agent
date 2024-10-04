/* using default substitutions */
SELECT
  YEAR(TO_DATE(orders.o_orderdate)) AS o_year,
  SUM(
    CASE
      WHEN n2.n_name = 'BRAZIL'
      THEN lineitem.l_extendedprice * (
        1 - lineitem.l_discount
      )
      ELSE 0
    END
  ) / SUM(lineitem.l_extendedprice * (
    1 - lineitem.l_discount
  )) AS mkt_share
FROM part AS part
JOIN region AS region
  ON region.r_name = 'MIDDLE EAST'
JOIN lineitem AS lineitem
  ON lineitem.l_partkey = part.p_partkey
JOIN nation AS n1
  ON n1.n_regionkey = region.r_regionkey
JOIN customer AS customer
  ON customer.c_nationkey = n1.n_nationkey
JOIN supplier AS supplier
  ON lineitem.l_suppkey = supplier.s_suppkey
JOIN nation AS n2
  ON n2.n_nationkey = supplier.s_nationkey
JOIN orders AS orders
  ON customer.c_custkey = orders.o_custkey
  AND lineitem.l_orderkey = orders.o_orderkey
  AND orders.o_orderdate < CAST('1997-10-31' AS DATE)
WHERE
  part.p_type LIKE '%BRASS'
GROUP BY
  YEAR(TO_DATE(orders.o_orderdate))
ORDER BY
  o_year