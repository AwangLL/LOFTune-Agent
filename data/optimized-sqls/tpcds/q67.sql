WITH dw1 AS (
  SELECT
    item.i_category AS i_category,
    item.i_class AS i_class,
    item.i_brand AS i_brand,
    item.i_product_name AS i_product_name,
    date_dim.d_year AS d_year,
    date_dim.d_qoy AS d_qoy,
    date_dim.d_moy AS d_moy,
    store.s_store_id AS s_store_id,
    SUM(COALESCE(store_sales.ss_sales_price * store_sales.ss_quantity, 0)) AS sumsales
  FROM store_sales AS store_sales
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = store_sales.ss_sold_date_sk
    AND date_dim.d_month_seq <= 1211
    AND date_dim.d_month_seq >= 1200
  JOIN item AS item
    ON item.i_item_sk = store_sales.ss_item_sk
  JOIN store AS store
    ON store.s_store_sk = store_sales.ss_store_sk
  GROUP BY
  ROLLUP (
    item.i_category,
    item.i_class,
    item.i_brand,
    item.i_product_name,
    date_dim.d_year,
    date_dim.d_qoy,
    date_dim.d_moy,
    store.s_store_id
  )
), dw2 AS (
  SELECT
    dw1.i_category AS i_category,
    dw1.i_class AS i_class,
    dw1.i_brand AS i_brand,
    dw1.i_product_name AS i_product_name,
    dw1.d_year AS d_year,
    dw1.d_qoy AS d_qoy,
    dw1.d_moy AS d_moy,
    dw1.s_store_id AS s_store_id,
    dw1.sumsales AS sumsales,
    RANK() OVER (PARTITION BY dw1.i_category ORDER BY dw1.sumsales DESC) AS rk
  FROM dw1 AS dw1
)
SELECT
  dw2.i_category AS i_category,
  dw2.i_class AS i_class,
  dw2.i_brand AS i_brand,
  dw2.i_product_name AS i_product_name,
  dw2.d_year AS d_year,
  dw2.d_qoy AS d_qoy,
  dw2.d_moy AS d_moy,
  dw2.s_store_id AS s_store_id,
  dw2.sumsales AS sumsales,
  dw2.rk AS rk
FROM dw2 AS dw2
WHERE
  dw2.rk <= 100
ORDER BY
  dw2.i_category,
  dw2.i_class,
  dw2.i_brand,
  dw2.i_product_name,
  dw2.d_year,
  dw2.d_qoy,
  dw2.d_moy,
  dw2.s_store_id,
  dw2.sumsales,
  dw2.rk
LIMIT 100