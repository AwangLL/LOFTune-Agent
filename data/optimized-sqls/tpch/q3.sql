/* using default substitutions */
SELECT
  lineitem.l_orderkey AS l_orderkey,
  SUM(lineitem.l_extendedprice * (
    1 - lineitem.l_discount
  )) AS revenue,
  orders.o_orderdate AS o_orderdate,
  orders.o_shippriority AS o_shippriority
FROM customer AS customer
JOIN orders AS orders
  ON customer.c_custkey = orders.o_custkey
  AND orders.o_orderdate < CAST('1995-03-15' AS DATE)
JOIN lineitem AS lineitem
  ON lineitem.l_orderkey = orders.o_orderkey
  AND lineitem.l_shipdate > CAST('1995-03-15' AS DATE)
WHERE
  customer.c_mktsegment = 'BUILDING'
GROUP BY
  lineitem.l_orderkey,
  orders.o_orderdate,
  orders.o_shippriority
ORDER BY
  revenue DESC,
  o_orderdate
LIMIT 10