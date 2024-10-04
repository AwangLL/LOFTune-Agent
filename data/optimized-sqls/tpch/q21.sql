/* using default substitutions */
SELECT
  supplier.s_name AS s_name,
  COUNT(*) AS numwait
FROM supplier AS supplier
JOIN lineitem AS l1
  ON NOT EXISTS(
    SELECT
      *
    FROM lineitem AS l3
    WHERE
      l1.l_orderkey = l3.l_orderkey
      AND l1.l_suppkey <> l3.l_suppkey
      AND l3.l_commitdate < l3.l_receiptdate
  )
  AND EXISTS(
    SELECT
      *
    FROM lineitem AS l2
    WHERE
      l1.l_orderkey = l2.l_orderkey AND l1.l_suppkey <> l2.l_suppkey
  )
  AND l1.l_commitdate < l1.l_receiptdate
  AND l1.l_suppkey = supplier.s_suppkey
JOIN nation AS nation
  ON nation.n_name = 'SAUDI ARABIA' AND nation.n_nationkey = supplier.s_nationkey
JOIN orders AS orders
  ON l1.l_orderkey = orders.o_orderkey AND orders.o_orderstatus = 'F'
GROUP BY
  supplier.s_name
ORDER BY
  numwait DESC,
  s_name
LIMIT 100