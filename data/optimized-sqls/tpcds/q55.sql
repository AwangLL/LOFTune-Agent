SELECT
  item.i_brand_id AS brand_id,
  item.i_brand AS brand,
  SUM(store_sales.ss_ext_sales_price) AS ext_price
FROM date_dim AS date_dim
JOIN store_sales AS store_sales
  ON date_dim.d_date_sk = store_sales.ss_sold_date_sk
JOIN item AS item
  ON item.i_item_sk = store_sales.ss_item_sk AND item.i_manager_id = 28
WHERE
  date_dim.d_moy = 11 AND date_dim.d_year = 1999
GROUP BY
  item.i_brand,
  item.i_brand_id
ORDER BY
  ext_price DESC,
  brand_id
LIMIT 100