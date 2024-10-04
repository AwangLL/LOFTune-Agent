SELECT
  SUM(store_sales.ss_quantity) AS _col_0
FROM store_sales AS store_sales
JOIN customer_address AS customer_address
  ON (
    NOT customer_address.ca_state IN ('CO', 'OH', 'TX')
    AND customer_address.ca_address_sk = store_sales.ss_addr_sk
    AND customer_address.ca_country <> 'United States'
    AND store_sales.ss_net_profit <= 4000
    AND store_sales.ss_net_profit >= 0
  )
  OR (
    customer_address.ca_address_sk = store_sales.ss_addr_sk
    AND customer_address.ca_country = 'United States'
    AND customer_address.ca_state IN ('KY', 'OR')
    AND store_sales.ss_net_profit <= 5000
    AND store_sales.ss_net_profit >= 70
  )
  OR (
    customer_address.ca_address_sk = store_sales.ss_addr_sk
    AND customer_address.ca_country = 'United States'
    AND customer_address.ca_state IN ('CA', 'MS', 'VA')
    AND store_sales.ss_net_profit <= 15000
    AND store_sales.ss_net_profit >= 20
  )
JOIN customer_demographics AS customer_demographics
  ON (
    customer_demographics.cd_demo_sk = store_sales.ss_cdemo_sk
    AND customer_demographics.cd_education_status = '2 yr Degree'
    AND customer_demographics.cd_marital_status = 'D'
    AND store_sales.ss_sales_price > 125.00
  )
  OR (
    customer_demographics.cd_demo_sk = store_sales.ss_cdemo_sk
    AND customer_demographics.cd_education_status = '4 yr Degree'
    AND customer_demographics.cd_marital_status = 'M'
    AND store_sales.ss_sales_price < 75.00
  )
  OR (
    customer_demographics.cd_demo_sk = store_sales.ss_cdemo_sk
    AND customer_demographics.cd_education_status = 'College'
    AND customer_demographics.cd_marital_status = 'S'
    AND store_sales.ss_sales_price <= 250.00
    AND store_sales.ss_sales_price >= 150.00
  )
JOIN date_dim AS date_dim
  ON date_dim.d_date_sk = store_sales.ss_sold_date_sk AND date_dim.d_year = 2001
JOIN store AS store
  ON store.s_store_sk = store_sales.ss_store_sk