WITH frequent_ss_items AS (
  SELECT
    item.i_item_sk AS item_sk
  FROM store_sales AS store_sales
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = store_sales.ss_sold_date_sk
    AND date_dim.d_year IN (2000, 2001, 2002, 2003)
  JOIN item AS item
    ON item.i_item_sk = store_sales.ss_item_sk
  GROUP BY
    SUBSTR(item.i_item_desc, 1, 30),
    item.i_item_sk,
    date_dim.d_date
  HAVING
    COUNT(*) > 4
), x AS (
  SELECT
    SUM(store_sales.ss_quantity * store_sales.ss_sales_price) AS csales
  FROM store_sales AS store_sales
  JOIN customer AS customer
    ON customer.c_customer_sk = store_sales.ss_customer_sk
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = store_sales.ss_sold_date_sk
    AND date_dim.d_year IN (2000, 2001, 2002, 2003)
  GROUP BY
    customer.c_customer_sk
), max_store_sales AS (
  SELECT
    MAX(x.csales) AS tpcds_cmax
  FROM x AS x
), _u_0 AS (
  SELECT
    max_store_sales.tpcds_cmax AS tpcds_cmax
  FROM max_store_sales
), best_ss_customer AS (
  SELECT
    customer.c_customer_sk AS c_customer_sk
  FROM store_sales AS store_sales
  CROSS JOIN _u_0 AS _u_0
  JOIN customer AS customer
    ON customer.c_customer_sk = store_sales.ss_customer_sk
  GROUP BY
    customer.c_customer_sk
  HAVING
    0.5 * MAX(_u_0.tpcds_cmax) < SUM(store_sales.ss_quantity * store_sales.ss_sales_price)
), _u_1 AS (
  SELECT
    frequent_ss_items.item_sk AS item_sk
  FROM frequent_ss_items
  GROUP BY
    frequent_ss_items.item_sk
), _u_2 AS (
  SELECT
    best_ss_customer.c_customer_sk AS c_customer_sk
  FROM best_ss_customer
  GROUP BY
    best_ss_customer.c_customer_sk
), y AS (
  (
    SELECT
      catalog_sales.cs_quantity * catalog_sales.cs_list_price AS sales
    FROM catalog_sales AS catalog_sales
    LEFT JOIN _u_1 AS _u_1
      ON `_u_1`.`item_sk` = catalog_sales.cs_item_sk
    LEFT JOIN _u_2 AS _u_2
      ON `_u_2`.`c_customer_sk` = catalog_sales.cs_bill_customer_sk
    JOIN date_dim AS date_dim
      ON catalog_sales.cs_sold_date_sk = date_dim.d_date_sk
      AND date_dim.d_moy = 2
      AND date_dim.d_year = 2000
    WHERE
      NOT `_u_1`.`item_sk` IS NULL AND NOT `_u_2`.`c_customer_sk` IS NULL
  )
  UNION ALL
  (
    SELECT
      web_sales.ws_quantity * web_sales.ws_list_price AS sales
    FROM web_sales AS web_sales
    LEFT JOIN _u_1 AS _u_3
      ON `_u_3`.`item_sk` = web_sales.ws_item_sk
    LEFT JOIN _u_2 AS _u_4
      ON `_u_4`.`c_customer_sk` = web_sales.ws_bill_customer_sk
    JOIN date_dim AS date_dim
      ON date_dim.d_date_sk = web_sales.ws_sold_date_sk
      AND date_dim.d_moy = 2
      AND date_dim.d_year = 2000
    WHERE
      NOT `_u_3`.`item_sk` IS NULL AND NOT `_u_4`.`c_customer_sk` IS NULL
  )
)
SELECT
  SUM(y.sales) AS _col_0
FROM y AS y
LIMIT 100