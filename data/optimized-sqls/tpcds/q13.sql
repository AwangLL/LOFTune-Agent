SELECT
  AVG(store_sales.ss_quantity) AS _col_0,
  AVG(store_sales.ss_ext_sales_price) AS _col_1,
  AVG(store_sales.ss_ext_wholesale_cost) AS _col_2,
  SUM(store_sales.ss_ext_wholesale_cost) AS _col_3
FROM store_sales AS store_sales
CROSS JOIN customer_demographics AS customer_demographics
JOIN customer_address AS customer_address
  ON (
    customer_address.ca_address_sk = store_sales.ss_addr_sk
    AND customer_address.ca_country = 'United States'
    AND customer_address.ca_state IN ('KY', 'NM', 'OR')
    AND store_sales.ss_net_profit <= 300
    AND store_sales.ss_net_profit >= 150
  )
  OR (
    customer_address.ca_address_sk = store_sales.ss_addr_sk
    AND customer_address.ca_country = 'United States'
    AND customer_address.ca_state IN ('OH', 'TX')
    AND store_sales.ss_net_profit <= 200
    AND store_sales.ss_net_profit >= 100
  )
  OR (
    customer_address.ca_address_sk = store_sales.ss_addr_sk
    AND customer_address.ca_country = 'United States'
    AND customer_address.ca_state IN ('MS', 'TX', 'VA')
    AND store_sales.ss_net_profit <= 250
    AND store_sales.ss_net_profit >= 50
  )
JOIN date_dim AS date_dim
  ON date_dim.d_date_sk = store_sales.ss_sold_date_sk AND date_dim.d_year = 2001
JOIN household_demographics AS household_demographics
  ON (
    customer_demographics.cd_demo_sk = store_sales.ss_cdemo_sk
    AND customer_demographics.cd_education_status = '2 yr Degree'
    AND customer_demographics.cd_marital_status = 'W'
    AND household_demographics.hd_demo_sk = store_sales.ss_hdemo_sk
    AND household_demographics.hd_dep_count = 1
    AND store_sales.ss_sales_price <= 200.00
    AND store_sales.ss_sales_price >= 150.00
  )
  OR (
    customer_demographics.cd_demo_sk = store_sales.ss_cdemo_sk
    AND customer_demographics.cd_education_status = 'Advanced Degree'
    AND customer_demographics.cd_marital_status = 'M'
    AND household_demographics.hd_demo_sk = store_sales.ss_hdemo_sk
    AND household_demographics.hd_dep_count = 3
    AND store_sales.ss_sales_price <= 150.00
    AND store_sales.ss_sales_price >= 100.00
  )
  OR (
    customer_demographics.cd_demo_sk = store_sales.ss_cdemo_sk
    AND customer_demographics.cd_education_status = 'College'
    AND customer_demographics.cd_marital_status = 'S'
    AND household_demographics.hd_demo_sk = store_sales.ss_hdemo_sk
    AND household_demographics.hd_dep_count = 1
    AND store_sales.ss_sales_price <= 100.00
    AND store_sales.ss_sales_price >= 50.00
  )
JOIN store AS store
  ON store.s_store_sk = store_sales.ss_store_sk