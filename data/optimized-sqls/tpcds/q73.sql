WITH dj AS (
  SELECT
    store_sales.ss_ticket_number AS ss_ticket_number,
    store_sales.ss_customer_sk AS ss_customer_sk,
    COUNT(*) AS cnt
  FROM store_sales AS store_sales
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = store_sales.ss_sold_date_sk
    AND date_dim.d_dom <= 2
    AND date_dim.d_dom >= 1
    AND date_dim.d_year IN (1999, 2000, 2001)
  JOIN household_demographics AS household_demographics
    ON CASE
      WHEN household_demographics.hd_vehicle_count > 0
      THEN household_demographics.hd_dep_count / household_demographics.hd_vehicle_count
      ELSE NULL
    END > 1
    AND (
      household_demographics.hd_buy_potential = '>10000'
      OR household_demographics.hd_buy_potential = 'unknown'
    )
    AND household_demographics.hd_demo_sk = store_sales.ss_hdemo_sk
    AND household_demographics.hd_vehicle_count > 0
  JOIN store AS store
    ON store.s_county IN ('Bronx County', 'Franklin Parish', 'Orange County', 'Williamson County')
    AND store.s_store_sk = store_sales.ss_store_sk
  GROUP BY
    store_sales.ss_ticket_number,
    store_sales.ss_customer_sk
)
SELECT
  customer.c_last_name AS c_last_name,
  customer.c_first_name AS c_first_name,
  customer.c_salutation AS c_salutation,
  customer.c_preferred_cust_flag AS c_preferred_cust_flag,
  dj.ss_ticket_number AS ss_ticket_number,
  dj.cnt AS cnt
FROM dj AS dj
JOIN customer AS customer
  ON customer.c_customer_sk = dj.ss_customer_sk
WHERE
  dj.cnt <= 5 AND dj.cnt >= 1
ORDER BY
  cnt DESC