SELECT
  dt.d_year AS d_year,
  item.i_brand_id AS brand_id,
  item.i_brand AS brand,
  SUM(store_sales.ss_ext_sales_price) AS sum_agg
FROM date_dim AS dt
JOIN store_sales AS store_sales
  ON dt.d_date_sk = store_sales.ss_sold_date_sk
JOIN item AS item
  ON item.i_item_sk = store_sales.ss_item_sk AND item.i_manufact_id = 128
WHERE
  dt.d_moy = 11
GROUP BY
  dt.d_year,
  item.i_brand,
  item.i_brand_id
ORDER BY
  d_year,
  sum_agg DESC,
  brand_id
LIMIT 100