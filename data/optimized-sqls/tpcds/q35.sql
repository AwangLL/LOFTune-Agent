WITH _u_0 AS (
  SELECT
    store_sales.ss_customer_sk AS _u_1
  FROM store_sales AS store_sales
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = store_sales.ss_sold_date_sk
    AND date_dim.d_qoy < 4
    AND date_dim.d_year = 2002
  GROUP BY
    store_sales.ss_customer_sk
), _u_2 AS (
  SELECT
    web_sales.ws_bill_customer_sk AS _u_3
  FROM web_sales AS web_sales
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = web_sales.ws_sold_date_sk
    AND date_dim.d_qoy < 4
    AND date_dim.d_year = 2002
  GROUP BY
    web_sales.ws_bill_customer_sk
), _u_4 AS (
  SELECT
    catalog_sales.cs_ship_customer_sk AS _u_5
  FROM catalog_sales AS catalog_sales
  JOIN date_dim AS date_dim
    ON catalog_sales.cs_sold_date_sk = date_dim.d_date_sk
    AND date_dim.d_qoy < 4
    AND date_dim.d_year = 2002
  GROUP BY
    catalog_sales.cs_ship_customer_sk
)
SELECT
  ca.ca_state AS ca_state,
  customer_demographics.cd_gender AS cd_gender,
  customer_demographics.cd_marital_status AS cd_marital_status,
  COUNT(*) AS cnt1,
  MIN(customer_demographics.cd_dep_count) AS _col_4,
  MAX(customer_demographics.cd_dep_count) AS _col_5,
  AVG(customer_demographics.cd_dep_count) AS _col_6,
  customer_demographics.cd_dep_employed_count AS cd_dep_employed_count,
  COUNT(*) AS cnt2,
  MIN(customer_demographics.cd_dep_employed_count) AS _col_9,
  MAX(customer_demographics.cd_dep_employed_count) AS _col_10,
  AVG(customer_demographics.cd_dep_employed_count) AS _col_11,
  customer_demographics.cd_dep_college_count AS cd_dep_college_count,
  COUNT(*) AS cnt3,
  MIN(customer_demographics.cd_dep_college_count) AS _col_14,
  MAX(customer_demographics.cd_dep_college_count) AS _col_15,
  AVG(customer_demographics.cd_dep_college_count) AS _col_16
FROM customer AS c
LEFT JOIN _u_0 AS _u_0
  ON _u_0._u_1 = c.c_customer_sk
LEFT JOIN _u_2 AS _u_2
  ON _u_2._u_3 = c.c_customer_sk
LEFT JOIN _u_4 AS _u_4
  ON _u_4._u_5 = c.c_customer_sk
JOIN customer_address AS ca
  ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics AS customer_demographics
  ON c.c_current_cdemo_sk = customer_demographics.cd_demo_sk
WHERE
  NOT _u_0._u_1 IS NULL AND (
    NOT _u_2._u_3 IS NULL OR NOT _u_4._u_5 IS NULL
  )
GROUP BY
  ca.ca_state,
  customer_demographics.cd_gender,
  customer_demographics.cd_marital_status,
  customer_demographics.cd_dep_count,
  customer_demographics.cd_dep_employed_count,
  customer_demographics.cd_dep_college_count
ORDER BY
  ca_state,
  cd_gender,
  cd_marital_status,
  customer_demographics.cd_dep_count,
  cd_dep_employed_count,
  cd_dep_college_count
LIMIT 100