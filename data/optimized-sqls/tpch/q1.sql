/* using default substitutions */
SELECT
  lineitem.l_returnflag AS l_returnflag,
  lineitem.l_linestatus AS l_linestatus,
  SUM(lineitem.l_quantity) AS sum_qty,
  SUM(lineitem.l_extendedprice) AS sum_base_price,
  SUM(lineitem.l_extendedprice * (
    1 - lineitem.l_discount
  )) AS sum_disc_price,
  SUM(
    lineitem.l_extendedprice * (
      1 - lineitem.l_discount
    ) * (
      1 + lineitem.l_tax
    )
  ) AS sum_charge,
  AVG(lineitem.l_quantity) AS avg_qty,
  AVG(lineitem.l_extendedprice) AS avg_price,
  AVG(lineitem.l_discount) AS avg_disc,
  COUNT(*) AS count_order
FROM lineitem AS lineitem
WHERE
  lineitem.l_shipdate <= CAST('1998-09-02' AS DATE)
GROUP BY
  lineitem.l_returnflag,
  lineitem.l_linestatus
ORDER BY
  l_returnflag,
  l_linestatus