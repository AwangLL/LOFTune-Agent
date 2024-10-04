/* using default substitutions */
SELECT
  SUM(lineitem.l_extendedprice * lineitem.l_discount) AS revenue
FROM lineitem AS lineitem
WHERE
  lineitem.l_discount <= 0.07
  AND lineitem.l_discount >= 0.05
  AND lineitem.l_quantity < 24
  AND lineitem.l_shipdate < CAST('1995-01-01' AS DATE)
  AND lineitem.l_shipdate >= CAST('1994-01-01' AS DATE)