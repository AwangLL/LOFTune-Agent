WITH dn AS (
  SELECT
    store_sales.ss_ticket_number AS ss_ticket_number,
    store_sales.ss_customer_sk AS ss_customer_sk,
    customer_address.ca_city AS bought_city,
    SUM(store_sales.ss_ext_sales_price) AS extended_price,
    SUM(store_sales.ss_ext_list_price) AS list_price,
    SUM(store_sales.ss_ext_tax) AS extended_tax
  FROM store_sales AS store_sales
  JOIN customer_address AS customer_address
    ON customer_address.ca_address_sk = store_sales.ss_addr_sk
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = store_sales.ss_sold_date_sk
    AND date_dim.d_dom <= 2
    AND date_dim.d_dom >= 1
    AND date_dim.d_year IN (1999, 2000, 2001)
  JOIN household_demographics AS household_demographics
    ON household_demographics.hd_demo_sk = store_sales.ss_hdemo_sk
    AND (
      household_demographics.hd_dep_count = 4
      OR household_demographics.hd_vehicle_count = 3
    )
  JOIN store AS store
    ON store.s_city IN ('Fairview', 'Midway') AND store.s_store_sk = store_sales.ss_store_sk
  GROUP BY
    store_sales.ss_ticket_number,
    store_sales.ss_customer_sk,
    store_sales.ss_addr_sk,
    customer_address.ca_city
)
SELECT
  customer.c_last_name AS c_last_name,
  customer.c_first_name AS c_first_name,
  current_addr.ca_city AS ca_city,
  dn.bought_city AS bought_city,
  dn.ss_ticket_number AS ss_ticket_number,
  dn.extended_price AS extended_price,
  dn.extended_tax AS extended_tax,
  dn.list_price AS list_price
FROM dn AS dn
JOIN customer AS customer
  ON customer.c_customer_sk = dn.ss_customer_sk
JOIN customer_address AS current_addr
  ON current_addr.ca_address_sk = customer.c_current_addr_sk
  AND current_addr.ca_city <> dn.bought_city
ORDER BY
  c_last_name,
  ss_ticket_number
LIMIT 100