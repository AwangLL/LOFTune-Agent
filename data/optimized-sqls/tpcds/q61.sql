WITH promotional_sales AS (
  SELECT
    SUM(store_sales.ss_ext_sales_price) AS promotions
  FROM store_sales AS store_sales
  JOIN customer AS customer
    ON customer.c_customer_sk = store_sales.ss_customer_sk
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = store_sales.ss_sold_date_sk
    AND date_dim.d_moy = 11
    AND date_dim.d_year = 1998
  JOIN item AS item
    ON item.i_category = 'Jewelry' AND item.i_item_sk = store_sales.ss_item_sk
  JOIN promotion AS promotion
    ON (
      promotion.p_channel_dmail = 'Y'
      OR promotion.p_channel_email = 'Y'
      OR promotion.p_channel_tv = 'Y'
    )
    AND promotion.p_promo_sk = store_sales.ss_promo_sk
  JOIN store AS store
    ON store.s_gmt_offset = -5 AND store.s_store_sk = store_sales.ss_store_sk
  JOIN customer_address AS customer_address
    ON customer.c_current_addr_sk = customer_address.ca_address_sk
    AND customer_address.ca_gmt_offset = -5
), all_sales AS (
  SELECT
    SUM(store_sales.ss_ext_sales_price) AS total
  FROM store_sales AS store_sales
  JOIN customer AS customer
    ON customer.c_customer_sk = store_sales.ss_customer_sk
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = store_sales.ss_sold_date_sk
    AND date_dim.d_moy = 11
    AND date_dim.d_year = 1998
  JOIN item AS item
    ON item.i_category = 'Jewelry' AND item.i_item_sk = store_sales.ss_item_sk
  JOIN store AS store
    ON store.s_gmt_offset = -5 AND store.s_store_sk = store_sales.ss_store_sk
  JOIN customer_address AS customer_address
    ON customer.c_current_addr_sk = customer_address.ca_address_sk
    AND customer_address.ca_gmt_offset = -5
)
SELECT
  promotional_sales.promotions AS promotions,
  all_sales.total AS total,
  CAST(promotional_sales.promotions AS DECIMAL(15, 4)) / CAST(all_sales.total AS DECIMAL(15, 4)) * 100 AS _col_2
FROM promotional_sales AS promotional_sales
CROSS JOIN all_sales AS all_sales
ORDER BY
  promotions,
  total
LIMIT 100