WITH revenue0 AS (
  SELECT
    lineitem.l_suppkey AS supplier_no,
    SUM(lineitem.l_extendedprice * (
      1 - lineitem.l_discount
    )) AS total_revenue
  FROM lineitem AS lineitem
  WHERE
    lineitem.l_shipdate < CAST('1996-04-01' AS DATE)
    AND lineitem.l_shipdate >= CAST('1996-01-01' AS DATE)
  GROUP BY
    lineitem.l_suppkey
), _u_0 AS (
  SELECT
    MAX(revenue0.total_revenue) AS _col_0
  FROM revenue0
)
SELECT
  supplier.s_suppkey AS s_suppkey,
  supplier.s_name AS s_name,
  supplier.s_address AS s_address,
  supplier.s_phone AS s_phone,
  revenue0.total_revenue AS total_revenue
FROM supplier AS supplier
JOIN revenue0
  ON revenue0.supplier_no = supplier.s_suppkey
JOIN _u_0 AS _u_0
  ON _u_0._col_0 = revenue0.total_revenue
ORDER BY
  s_suppkey