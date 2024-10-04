SELECT
  item.i_item_id AS i_item_id,
  AVG(store_sales.ss_quantity) AS agg1,
  AVG(store_sales.ss_list_price) AS agg2,
  AVG(store_sales.ss_coupon_amt) AS agg3,
  AVG(store_sales.ss_sales_price) AS agg4
FROM store_sales AS store_sales
JOIN customer_demographics AS customer_demographics
  ON customer_demographics.cd_demo_sk = store_sales.ss_cdemo_sk
  AND customer_demographics.cd_education_status = 'College'
  AND customer_demographics.cd_gender = 'M'
  AND customer_demographics.cd_marital_status = 'S'
JOIN date_dim AS date_dim
  ON date_dim.d_date_sk = store_sales.ss_sold_date_sk AND date_dim.d_year = 2000
JOIN item AS item
  ON item.i_item_sk = store_sales.ss_item_sk
JOIN promotion AS promotion
  ON (
    promotion.p_channel_email = 'N' OR promotion.p_channel_event = 'N'
  )
  AND promotion.p_promo_sk = store_sales.ss_promo_sk
GROUP BY
  item.i_item_id
ORDER BY
  i_item_id
LIMIT 100