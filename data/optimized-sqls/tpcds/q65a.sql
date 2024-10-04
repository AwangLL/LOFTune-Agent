WITH sc AS (
  SELECT
    store_sales.ss_store_sk AS ss_store_sk,
    store_sales.ss_item_sk AS ss_item_sk,
    SUM(store_sales.ss_sales_price) AS revenue
  FROM store_sales AS store_sales
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = store_sales.ss_sold_date_sk AND date_dim.d_month_seq < 1200
  GROUP BY
    store_sales.ss_store_sk,
    store_sales.ss_item_sk
), sa AS (
  SELECT
    store_sales.ss_store_sk AS ss_store_sk,
    SUM(store_sales.ss_sales_price) AS revenue
  FROM store_sales AS store_sales
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = store_sales.ss_sold_date_sk AND date_dim.d_month_seq > 1172
  GROUP BY
    store_sales.ss_store_sk,
    store_sales.ss_item_sk
), sb AS (
  SELECT
    sa.ss_store_sk AS ss_store_sk,
    AVG(sa.revenue) AS ave
  FROM sa AS sa
  GROUP BY
    sa.ss_store_sk
)
SELECT
  store.s_store_name AS s_store_name,
  item.i_item_desc AS i_item_desc,
  sc.revenue AS revenue,
  item.i_current_price AS i_current_price,
  item.i_wholesale_cost AS i_wholesale_cost,
  item.i_brand AS i_brand
FROM store AS store
JOIN sc AS sc
  ON sc.ss_store_sk = store.s_store_sk
JOIN item AS item
  ON item.i_item_sk = sc.ss_item_sk
JOIN sb AS sb
  ON sb.ss_store_sk = sc.ss_store_sk AND sc.revenue >= 0.05 * sb.ave
ORDER BY
  s_store_name,
  i_item_desc
LIMIT 100