/* using default substitutions */
WITH _u_0 AS (
  SELECT
    part.p_partkey AS p_partkey
  FROM part AS part
  WHERE
    part.p_name LIKE 'forest%'
  GROUP BY
    part.p_partkey
), _u_1 AS (
  SELECT
    0.5 * SUM(lineitem.l_quantity) AS _col_0,
    lineitem.l_partkey AS _u_2,
    lineitem.l_suppkey AS _u_3
  FROM lineitem AS lineitem
  WHERE
    lineitem.l_shipdate < CAST('1995-01-01' AS DATE)
    AND lineitem.l_shipdate >= CAST('1994-01-01' AS DATE)
  GROUP BY
    lineitem.l_partkey,
    lineitem.l_suppkey
), _u_4 AS (
  SELECT
    partsupp.ps_suppkey AS ps_suppkey
  FROM partsupp AS partsupp
  LEFT JOIN _u_0 AS _u_0
    ON `_u_0`.`p_partkey` = partsupp.ps_partkey
  LEFT JOIN _u_1 AS _u_1
    ON _u_1._u_2 = partsupp.ps_partkey AND _u_1._u_3 = partsupp.ps_suppkey
  WHERE
    NOT `_u_0`.`p_partkey` IS NULL AND _u_1._col_0 < partsupp.ps_availqty
  GROUP BY
    partsupp.ps_suppkey
)
SELECT
  supplier.s_name AS s_name,
  supplier.s_address AS s_address
FROM supplier AS supplier
LEFT JOIN _u_4 AS _u_4
  ON `_u_4`.`ps_suppkey` = supplier.s_suppkey
JOIN nation AS nation
  ON nation.n_name = 'CANADA' AND nation.n_nationkey = supplier.s_nationkey
WHERE
  NOT `_u_4`.`ps_suppkey` IS NULL
ORDER BY
  s_name