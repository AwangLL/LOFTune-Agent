/* using default substitutions */
WITH _u_0 AS (
  SELECT
    SUM(partsupp.ps_supplycost * partsupp.ps_availqty) * 0.0001000000 AS _col_0
  FROM partsupp AS partsupp
  JOIN supplier AS supplier
    ON partsupp.ps_suppkey = supplier.s_suppkey
  JOIN nation AS nation
    ON nation.n_name = 'GERMANY' AND nation.n_nationkey = supplier.s_nationkey
)
SELECT
  partsupp.ps_partkey AS ps_partkey,
  SUM(partsupp.ps_supplycost * partsupp.ps_availqty) AS value
FROM partsupp AS partsupp
CROSS JOIN _u_0 AS _u_0
JOIN supplier AS supplier
  ON partsupp.ps_suppkey = supplier.s_suppkey
JOIN nation AS nation
  ON nation.n_name = 'GERMANY' AND nation.n_nationkey = supplier.s_nationkey
GROUP BY
  partsupp.ps_partkey
HAVING
  MAX(_u_0._col_0) < SUM(partsupp.ps_supplycost * partsupp.ps_availqty)
ORDER BY
  value DESC