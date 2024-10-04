WITH foo AS (
  SELECT
    'store' AS channel,
    store_sales.ss_store_sk AS col_name,
    date_dim.d_year AS d_year,
    date_dim.d_qoy AS d_qoy,
    item.i_category AS i_category,
    store_sales.ss_ext_sales_price AS ext_sales_price
  FROM store_sales AS store_sales
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = store_sales.ss_sold_date_sk
  JOIN item AS item
    ON item.i_item_sk = store_sales.ss_item_sk
  WHERE
    store_sales.ss_store_sk IS NULL
  UNION ALL
  SELECT
    'web' AS channel,
    web_sales.ws_ship_customer_sk AS col_name,
    date_dim.d_year AS d_year,
    date_dim.d_qoy AS d_qoy,
    item.i_category AS i_category,
    web_sales.ws_ext_sales_price AS ext_sales_price
  FROM web_sales AS web_sales
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = web_sales.ws_sold_date_sk
  JOIN item AS item
    ON item.i_item_sk = web_sales.ws_item_sk
  WHERE
    web_sales.ws_ship_customer_sk IS NULL
  UNION ALL
  SELECT
    'catalog' AS channel,
    catalog_sales.cs_ship_addr_sk AS col_name,
    date_dim.d_year AS d_year,
    date_dim.d_qoy AS d_qoy,
    item.i_category AS i_category,
    catalog_sales.cs_ext_sales_price AS ext_sales_price
  FROM catalog_sales AS catalog_sales
  JOIN date_dim AS date_dim
    ON catalog_sales.cs_sold_date_sk = date_dim.d_date_sk
  JOIN item AS item
    ON catalog_sales.cs_item_sk = item.i_item_sk
  WHERE
    catalog_sales.cs_ship_addr_sk IS NULL
)
SELECT
  foo.channel AS channel,
  foo.col_name AS col_name,
  foo.d_year AS d_year,
  foo.d_qoy AS d_qoy,
  foo.i_category AS i_category,
  COUNT(*) AS sales_cnt,
  SUM(foo.ext_sales_price) AS sales_amt
FROM foo AS foo
GROUP BY
  foo.channel,
  foo.col_name,
  foo.d_year,
  foo.d_qoy,
  foo.i_category
ORDER BY
  channel,
  col_name,
  d_year,
  d_qoy,
  i_category
LIMIT 100