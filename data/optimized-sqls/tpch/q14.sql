/* using default substitutions */
SELECT
  100.00 * SUM(
    CASE
      WHEN part.p_type LIKE 'PROMO%'
      THEN lineitem.l_extendedprice * (
        1 - lineitem.l_discount
      )
      ELSE 0
    END
  ) / SUM(lineitem.l_extendedprice * (
    1 - lineitem.l_discount
  )) AS promo_revenue
FROM lineitem AS lineitem
JOIN part AS part
  ON lineitem.l_partkey = part.p_partkey
WHERE
  lineitem.l_shipdate < CAST('1995-10-01' AS DATE)
  AND lineitem.l_shipdate >= CAST('1995-09-01' AS DATE)