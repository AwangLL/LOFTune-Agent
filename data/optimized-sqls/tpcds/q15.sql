SELECT
  customer_address.ca_zip AS ca_zip,
  SUM(catalog_sales.cs_sales_price) AS _col_1
FROM catalog_sales AS catalog_sales
JOIN customer_address AS customer_address
  ON SUBSTR(customer_address.ca_zip, 1, 5) IN ('80348', '81792', '83405', '85392', '85460', '85669', '86197', '86475', '88274')
  OR catalog_sales.cs_sales_price > 500
  OR customer_address.ca_state IN ('CA', 'GA', 'WA')
JOIN date_dim AS date_dim
  ON catalog_sales.cs_sold_date_sk = date_dim.d_date_sk
  AND date_dim.d_qoy = 2
  AND date_dim.d_year = 2001
JOIN customer AS customer
  ON catalog_sales.cs_bill_customer_sk = customer.c_customer_sk
  AND customer.c_current_addr_sk = customer_address.ca_address_sk
GROUP BY
  customer_address.ca_zip
ORDER BY
  ca_zip
LIMIT 100