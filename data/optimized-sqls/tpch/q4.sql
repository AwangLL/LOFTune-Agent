/* using default substitutions */
WITH _u_0 AS (
  SELECT
    lineitem.l_orderkey AS l_orderkey
  FROM lineitem AS lineitem
  WHERE
    lineitem.l_commitdate < lineitem.l_receiptdate
  GROUP BY
    lineitem.l_orderkey
)
SELECT
  orders.o_orderpriority AS o_orderpriority,
  COUNT(*) AS order_count
FROM orders AS orders
LEFT JOIN _u_0 AS _u_0
  ON _u_0.l_orderkey = orders.o_orderkey
WHERE
  NOT _u_0.l_orderkey IS NULL
  AND orders.o_orderdate < CAST('1993-10-01' AS DATE)
  AND orders.o_orderdate >= CAST('1993-07-01' AS DATE)
GROUP BY
  orders.o_orderpriority
ORDER BY
  o_orderpriority