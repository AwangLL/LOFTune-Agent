SELECT
  SUM(store_sales.ss_quantity) AS _col_0
FROM store_sales AS store_sales
JOIN customer_address AS customer_address
  ON (
    customer_address.ca_address_sk = store_sales.ss_addr_sk
    AND customer_address.ca_country = 'United States'
    AND customer_address.ca_state IN ('CO', 'OH', 'TX')
    AND store_sales.ss_net_profit <= 2000
    AND store_sales.ss_net_profit >= 0
  )
  OR (
    customer_address.ca_address_sk = store_sales.ss_addr_sk
    AND customer_address.ca_country = 'United States'
    AND customer_address.ca_state IN ('KY', 'MN', 'OR')
    AND store_sales.ss_net_profit <= 3000
    AND store_sales.ss_net_profit >= 150
  )
  OR (
    customer_address.ca_address_sk = store_sales.ss_addr_sk
    AND customer_address.ca_country = 'United States'
    AND customer_address.ca_state IN ('CA', 'MS', 'VA')
    AND store_sales.ss_net_profit <= 25000
    AND store_sales.ss_net_profit >= 50
  )
JOIN customer_demographics AS customer_demographics
  ON (
    customer_demographics.cd_demo_sk = store_sales.ss_cdemo_sk
    AND customer_demographics.cd_education_status = '2 yr Degree'
    AND customer_demographics.cd_marital_status = 'D'
    AND store_sales.ss_sales_price <= 100.00
    AND store_sales.ss_sales_price >= 50.00
  )
  OR (
    customer_demographics.cd_demo_sk = store_sales.ss_cdemo_sk
    AND customer_demographics.cd_education_status = '4 yr Degree'
    AND customer_demographics.cd_marital_status = 'M'
    AND store_sales.ss_sales_price <= 150.00
    AND store_sales.ss_sales_price >= 100.00
  )
  OR (
    customer_demographics.cd_demo_sk = store_sales.ss_cdemo_sk
    AND customer_demographics.cd_education_status = 'College'
    AND customer_demographics.cd_marital_status = 'S'
    AND store_sales.ss_sales_price <= 200.00
    AND store_sales.ss_sales_price >= 150.00
  )
JOIN date_dim AS date_dim
  ON date_dim.d_date_sk = store_sales.ss_sold_date_sk AND date_dim.d_year = 2001
JOIN store AS store
  ON store.s_store_sk = store_sales.ss_store_sk