/* using default substitutions */
SELECT
  lineitem.l_shipmode AS l_shipmode,
  SUM(
    CASE
      WHEN orders.o_orderpriority = '1-URGENT' OR orders.o_orderpriority = '3-MEDIUM'
      THEN 1
      ELSE 0
    END
  ) AS high_line_count,
  SUM(CASE WHEN orders.o_orderpriority = '4-NOT SPECIFIED' THEN 1 ELSE 0 END) AS low_line_count
FROM orders AS orders
JOIN lineitem AS lineitem
  ON lineitem.l_commitdate < lineitem.l_receiptdate
  AND lineitem.l_commitdate > lineitem.l_shipdate
  AND lineitem.l_orderkey = orders.o_orderkey
  AND lineitem.l_receiptdate < CAST('1995-01-01' AS DATE)
  AND lineitem.l_receiptdate > CAST('1993-05-21' AS DATE)
  AND lineitem.l_shipmode IN ('MAIL', 'SHIP')
GROUP BY
  lineitem.l_shipmode
ORDER BY
  l_shipmode