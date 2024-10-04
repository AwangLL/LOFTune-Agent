/* using default substitutions */
WITH c_orders AS (
  SELECT
    COUNT(orders.o_orderkey) AS c_count
  FROM customer AS customer
  LEFT JOIN orders AS orders
    ON NOT orders.o_comment LIKE '%special%requests%'
    AND customer.c_custkey = orders.o_custkey
  GROUP BY
    customer.c_custkey
)
SELECT
  c_orders.c_count AS c_count,
  COUNT(*) AS custdist
FROM c_orders AS c_orders
GROUP BY
  c_orders.c_count
ORDER BY
  custdist DESC,
  c_count DESC