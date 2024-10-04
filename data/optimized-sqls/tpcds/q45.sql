WITH _u_0 AS (
  SELECT
    item.i_item_id AS i_item_id
  FROM item AS item
  WHERE
    item.i_item_sk IN (2, 3, 5, 7, 11, 13, 17, 19, 23, 29)
  GROUP BY
    item.i_item_id
)
SELECT
  customer_address.ca_zip AS ca_zip,
  customer_address.ca_city AS ca_city,
  SUM(web_sales.ws_sales_price) AS _col_2
FROM web_sales AS web_sales
JOIN customer AS customer
  ON customer.c_customer_sk = web_sales.ws_bill_customer_sk
JOIN date_dim AS date_dim
  ON date_dim.d_date_sk = web_sales.ws_sold_date_sk
  AND date_dim.d_qoy = 2
  AND date_dim.d_year = 2001
JOIN item AS item
  ON item.i_item_sk = web_sales.ws_item_sk
LEFT JOIN _u_0 AS _u_0
  ON `_u_0`.`i_item_id` = item.i_item_id
JOIN customer_address AS customer_address
  ON customer.c_current_addr_sk = customer_address.ca_address_sk
WHERE
  NOT `_u_0`.`i_item_id` IS NULL
  OR SUBSTR(customer_address.ca_zip, 1, 5) IN ('80348', '81792', '83405', '85392', '85460', '85669', '86197', '86475', '88274')
GROUP BY
  customer_address.ca_zip,
  customer_address.ca_city
ORDER BY
  ca_zip,
  ca_city
LIMIT 100