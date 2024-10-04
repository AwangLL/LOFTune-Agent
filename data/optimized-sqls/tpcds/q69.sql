WITH _u_0 AS (
  SELECT
    store_sales.ss_customer_sk AS _u_1
  FROM store_sales AS store_sales
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = store_sales.ss_sold_date_sk
    AND date_dim.d_moy <= 6
    AND date_dim.d_moy >= 4
    AND date_dim.d_year = 2001
  GROUP BY
    store_sales.ss_customer_sk
), _u_2 AS (
  SELECT
    web_sales.ws_bill_customer_sk AS _u_3
  FROM web_sales AS web_sales
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = web_sales.ws_sold_date_sk
    AND date_dim.d_moy <= 6
    AND date_dim.d_moy >= 4
    AND date_dim.d_year = 2001
  GROUP BY
    web_sales.ws_bill_customer_sk
), _u_4 AS (
  SELECT
    catalog_sales.cs_ship_customer_sk AS _u_5
  FROM catalog_sales AS catalog_sales
  JOIN date_dim AS date_dim
    ON catalog_sales.cs_sold_date_sk = date_dim.d_date_sk
    AND date_dim.d_moy <= 6
    AND date_dim.d_moy >= 4
    AND date_dim.d_year = 2001
  GROUP BY
    catalog_sales.cs_ship_customer_sk
)
SELECT
  customer_demographics.cd_gender AS cd_gender,
  customer_demographics.cd_marital_status AS cd_marital_status,
  customer_demographics.cd_education_status AS cd_education_status,
  COUNT(*) AS cnt1,
  customer_demographics.cd_purchase_estimate AS cd_purchase_estimate,
  COUNT(*) AS cnt2,
  customer_demographics.cd_credit_rating AS cd_credit_rating,
  COUNT(*) AS cnt3
FROM customer AS c
LEFT JOIN _u_0 AS _u_0
  ON _u_0._u_1 = c.c_customer_sk
LEFT JOIN _u_2 AS _u_2
  ON _u_2._u_3 = c.c_customer_sk
LEFT JOIN _u_4 AS _u_4
  ON _u_4._u_5 = c.c_customer_sk
JOIN customer_address AS ca
  ON c.c_current_addr_sk = ca.ca_address_sk AND ca.ca_state IN ('GA', 'KY', 'NM')
JOIN customer_demographics AS customer_demographics
  ON c.c_current_cdemo_sk = customer_demographics.cd_demo_sk
WHERE
  NOT _u_0._u_1 IS NULL AND _u_2._u_3 IS NULL AND _u_4._u_5 IS NULL
GROUP BY
  customer_demographics.cd_gender,
  customer_demographics.cd_marital_status,
  customer_demographics.cd_education_status,
  customer_demographics.cd_purchase_estimate,
  customer_demographics.cd_credit_rating
ORDER BY
  cd_gender,
  cd_marital_status,
  cd_education_status,
  cd_purchase_estimate,
  cd_credit_rating
LIMIT 100