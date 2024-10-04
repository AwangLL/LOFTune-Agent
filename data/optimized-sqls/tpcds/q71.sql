WITH tmp AS (
  SELECT
    web_sales.ws_ext_sales_price AS ext_price,
    web_sales.ws_item_sk AS sold_item_sk,
    web_sales.ws_sold_time_sk AS time_sk
  FROM web_sales AS web_sales
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = web_sales.ws_sold_date_sk
    AND date_dim.d_moy = 11
    AND date_dim.d_year = 1999
  UNION ALL
  SELECT
    catalog_sales.cs_ext_sales_price AS ext_price,
    catalog_sales.cs_item_sk AS sold_item_sk,
    catalog_sales.cs_sold_time_sk AS time_sk
  FROM catalog_sales AS catalog_sales
  JOIN date_dim AS date_dim
    ON catalog_sales.cs_sold_date_sk = date_dim.d_date_sk
    AND date_dim.d_moy = 11
    AND date_dim.d_year = 1999
  UNION ALL
  SELECT
    store_sales.ss_ext_sales_price AS ext_price,
    store_sales.ss_item_sk AS sold_item_sk,
    store_sales.ss_sold_time_sk AS time_sk
  FROM store_sales AS store_sales
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = store_sales.ss_sold_date_sk
    AND date_dim.d_moy = 11
    AND date_dim.d_year = 1999
)
SELECT
  item.i_brand_id AS brand_id,
  item.i_brand AS brand,
  time_dim.t_hour AS t_hour,
  time_dim.t_minute AS t_minute,
  SUM(tmp.ext_price) AS ext_price
FROM item AS item
JOIN tmp AS tmp
  ON item.i_item_sk = tmp.sold_item_sk
JOIN time_dim AS time_dim
  ON (
    time_dim.t_meal_time = 'breakfast' OR time_dim.t_meal_time = 'dinner'
  )
  AND time_dim.t_time_sk = tmp.time_sk
WHERE
  item.i_manager_id = 1
GROUP BY
  item.i_brand,
  item.i_brand_id,
  time_dim.t_hour,
  time_dim.t_minute
ORDER BY
  ext_price DESC,
  brand_id