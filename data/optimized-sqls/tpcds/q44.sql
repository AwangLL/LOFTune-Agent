WITH _u_0 AS (
  SELECT
    AVG(store_sales.ss_net_profit) AS rank_col
  FROM store_sales AS store_sales
  WHERE
    store_sales.ss_addr_sk IS NULL AND store_sales.ss_store_sk = 4
  GROUP BY
    store_sales.ss_store_sk
), v1 AS (
  SELECT
    ss1.ss_item_sk AS item_sk,
    AVG(ss1.ss_net_profit) AS rank_col
  FROM store_sales AS ss1
  CROSS JOIN _u_0 AS _u_0
  WHERE
    ss1.ss_store_sk = 4
  GROUP BY
    ss1.ss_item_sk
  HAVING
    0.9 * MAX(_u_0.rank_col) < AVG(ss1.ss_net_profit)
), v11 AS (
  SELECT
    v1.item_sk AS item_sk,
    RANK() OVER (ORDER BY v1.rank_col) AS rnk
  FROM v1 AS v1
), asceding AS (
  SELECT
    v11.item_sk AS item_sk,
    v11.rnk AS rnk
  FROM v11 AS v11
  WHERE
    v11.rnk < 11
), v2 AS (
  SELECT
    ss1.ss_item_sk AS item_sk,
    AVG(ss1.ss_net_profit) AS rank_col
  FROM store_sales AS ss1
  CROSS JOIN _u_0 AS _u_1
  WHERE
    ss1.ss_store_sk = 4
  GROUP BY
    ss1.ss_item_sk
  HAVING
    0.9 * MAX(_u_1.rank_col) < AVG(ss1.ss_net_profit)
), v21 AS (
  SELECT
    v2.item_sk AS item_sk,
    RANK() OVER (ORDER BY v2.rank_col DESC) AS rnk
  FROM v2 AS v2
), descending AS (
  SELECT
    v21.item_sk AS item_sk,
    v21.rnk AS rnk
  FROM v21 AS v21
  WHERE
    v21.rnk < 11
)
SELECT
  asceding.rnk AS rnk,
  i1.i_product_name AS best_performing,
  i2.i_product_name AS worst_performing
FROM asceding AS asceding
JOIN descending AS descending
  ON asceding.rnk = descending.rnk
JOIN item AS i1
  ON asceding.item_sk = i1.i_item_sk
JOIN item AS i2
  ON descending.item_sk = i2.i_item_sk
ORDER BY
  asceding.rnk
LIMIT 100