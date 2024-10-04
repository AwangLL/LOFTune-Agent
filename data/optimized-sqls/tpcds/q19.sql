SELECT
  item.i_brand_id AS brand_id,
  item.i_brand AS brand,
  item.i_manufact_id AS i_manufact_id,
  item.i_manufact AS i_manufact,
  SUM(store_sales.ss_ext_sales_price) AS ext_price
FROM date_dim AS date_dim
JOIN store_sales AS store_sales
  ON date_dim.d_date_sk = store_sales.ss_sold_date_sk
JOIN item AS item
  ON item.i_item_sk = store_sales.ss_item_sk AND item.i_manager_id = 8
JOIN store AS store
  ON store.s_store_sk = store_sales.ss_store_sk
JOIN customer_address AS customer_address
  ON SUBSTR(customer_address.ca_zip, 1, 5) <> SUBSTR(store.s_zip, 1, 5)
JOIN customer AS customer
  ON customer.c_current_addr_sk = customer_address.ca_address_sk
  AND customer.c_customer_sk = store_sales.ss_customer_sk
WHERE
  date_dim.d_moy = 11 AND date_dim.d_year = 1998
GROUP BY
  item.i_brand,
  item.i_brand_id,
  item.i_manufact_id,
  item.i_manufact
ORDER BY
  ext_price DESC,
  brand,
  brand_id,
  i_manufact_id,
  i_manufact
LIMIT 100