/* using default substitutions */
WITH _u_0 AS (
  SELECT
    supplier.s_suppkey AS s_suppkey
  FROM supplier AS supplier
  WHERE
    supplier.s_comment LIKE '%Customer%Complaints%'
  GROUP BY
    supplier.s_suppkey
)
SELECT
  part.p_brand AS p_brand,
  part.p_type AS p_type,
  part.p_size AS p_size,
  COUNT(DISTINCT partsupp.ps_suppkey) AS supplier_cnt
FROM partsupp AS partsupp
LEFT JOIN _u_0 AS _u_0
  ON `_u_0`.`s_suppkey` = partsupp.ps_suppkey
JOIN part AS part
  ON NOT part.p_type LIKE 'MEDIUM POLISHED%'
  AND part.p_brand <> 'Brand#45'
  AND part.p_partkey = partsupp.ps_partkey
  AND part.p_size IN (3, 9, 14, 19, 23, 36, 45, 49)
WHERE
  `_u_0`.`s_suppkey` IS NULL
GROUP BY
  part.p_brand,
  part.p_type,
  part.p_size
ORDER BY
  supplier_cnt DESC,
  p_brand,
  p_type,
  p_size