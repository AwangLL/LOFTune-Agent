SELECT
  dt.d_year AS d_year,
  item.i_brand_id AS brand_id,
  item.i_brand AS brand,
  SUM(store_sales.ss_ext_sales_price) AS ext_price
FROM date_dim AS dt
JOIN store_sales AS store_sales
  ON dt.d_date_sk = store_sales.ss_sold_date_sk
JOIN item AS item
  ON item.i_item_sk = store_sales.ss_item_sk AND item.i_manager_id = 1
WHERE
  dt.d_moy = 11 AND dt.d_year = 2000
GROUP BY
  dt.d_year,
  item.i_brand,
  item.i_brand_id
ORDER BY
  d_year,
  ext_price DESC,
  brand_id
LIMIT 100