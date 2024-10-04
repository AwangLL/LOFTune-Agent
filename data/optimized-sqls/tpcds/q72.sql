SELECT
  item.i_item_desc AS i_item_desc,
  warehouse.w_warehouse_name AS w_warehouse_name,
  d1.d_week_seq AS d_week_seq,
  COUNT(CASE WHEN promotion.p_promo_sk IS NULL THEN 1 ELSE 0 END) AS no_promo,
  COUNT(CASE WHEN NOT promotion.p_promo_sk IS NULL THEN 1 ELSE 0 END) AS promo,
  COUNT(*) AS total_cnt
FROM catalog_sales AS catalog_sales
LEFT JOIN catalog_returns AS catalog_returns
  ON catalog_returns.cr_item_sk = catalog_sales.cs_item_sk
  AND catalog_returns.cr_order_number = catalog_sales.cs_order_number
JOIN customer_demographics AS customer_demographics
  ON catalog_sales.cs_bill_cdemo_sk = customer_demographics.cd_demo_sk
  AND customer_demographics.cd_marital_status = 'D'
JOIN date_dim AS d3
  ON catalog_sales.cs_ship_date_sk = d3.d_date_sk
JOIN household_demographics AS household_demographics
  ON catalog_sales.cs_bill_hdemo_sk = household_demographics.hd_demo_sk
  AND household_demographics.hd_buy_potential = '>10000'
JOIN inventory AS inventory
  ON catalog_sales.cs_item_sk = inventory.inv_item_sk
  AND catalog_sales.cs_quantity > inventory.inv_quantity_on_hand
JOIN item AS item
  ON catalog_sales.cs_item_sk = item.i_item_sk
LEFT JOIN promotion AS promotion
  ON catalog_sales.cs_promo_sk = promotion.p_promo_sk
JOIN date_dim AS d2
  ON d2.d_date_sk = inventory.inv_date_sk
JOIN warehouse AS warehouse
  ON inventory.inv_warehouse_sk = warehouse.w_warehouse_sk
JOIN date_dim AS d1
  ON catalog_sales.cs_sold_date_sk = d1.d_date_sk
  AND d1.d_week_seq = d2.d_week_seq
  AND d1.d_year = 1999
  AND d3.d_date > (
    CAST(d1.d_date AS DATE) + INTERVAL '5' DAYS
  )
GROUP BY
  item.i_item_desc,
  warehouse.w_warehouse_name,
  d1.d_week_seq
ORDER BY
  total_cnt DESC,
  i_item_desc,
  w_warehouse_name,
  d_week_seq
LIMIT 100