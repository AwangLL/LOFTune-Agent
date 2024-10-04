/* using default substitutions */
WITH _u_0 AS (
  SELECT
    MIN(partsupp.ps_supplycost) AS _col_0,
    partsupp.ps_partkey AS _u_1
  FROM partsupp AS partsupp
  JOIN supplier AS supplier
    ON partsupp.ps_suppkey = supplier.s_suppkey
  JOIN nation AS nation
    ON nation.n_nationkey = supplier.s_nationkey
  JOIN region AS region
    ON nation.n_regionkey = region.r_regionkey AND region.r_name = 'AMERICA'
  GROUP BY
    partsupp.ps_partkey
)
SELECT
  supplier.s_acctbal AS s_acctbal,
  supplier.s_name AS s_name,
  nation.n_name AS n_name,
  part.p_partkey AS p_partkey,
  part.p_mfgr AS p_mfgr,
  supplier.s_address AS s_address,
  supplier.s_phone AS s_phone,
  supplier.s_comment AS s_comment
FROM part AS part
JOIN region AS region
  ON region.r_name = 'ASIA'
LEFT JOIN _u_0 AS _u_0
  ON _u_0._u_1 = part.p_partkey
JOIN nation AS nation
  ON nation.n_regionkey = region.r_regionkey
JOIN partsupp AS partsupp
  ON part.p_partkey = partsupp.ps_partkey
JOIN supplier AS supplier
  ON nation.n_nationkey = supplier.s_nationkey
  AND partsupp.ps_suppkey = supplier.s_suppkey
WHERE
  _u_0._col_0 = partsupp.ps_supplycost AND part.p_size < 17 AND part.p_type LIKE '%BRASS'
ORDER BY
  s_acctbal DESC,
  n_name,
  s_name,
  p_partkey
LIMIT 100