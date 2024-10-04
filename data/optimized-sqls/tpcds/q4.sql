WITH year_total AS (
  SELECT
    customer.c_customer_id AS customer_id,
    customer.c_first_name AS customer_first_name,
    customer.c_last_name AS customer_last_name,
    customer.c_preferred_cust_flag AS customer_preferred_cust_flag,
    customer.c_birth_country AS customer_birth_country,
    customer.c_login AS customer_login,
    customer.c_email_address AS customer_email_address,
    date_dim.d_year AS dyear,
    SUM(
      (
        (
          store_sales.ss_ext_list_price - store_sales.ss_ext_wholesale_cost - store_sales.ss_ext_discount_amt
        ) + store_sales.ss_ext_sales_price
      ) / 2
    ) AS year_total,
    's' AS sale_type
  FROM customer AS customer
  JOIN store_sales AS store_sales
    ON customer.c_customer_sk = store_sales.ss_customer_sk
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = store_sales.ss_sold_date_sk
  GROUP BY
    customer.c_customer_id,
    customer.c_first_name,
    customer.c_last_name,
    customer.c_preferred_cust_flag,
    customer.c_birth_country,
    customer.c_login,
    customer.c_email_address,
    date_dim.d_year
  UNION ALL
  SELECT
    customer.c_customer_id AS customer_id,
    customer.c_first_name AS customer_first_name,
    customer.c_last_name AS customer_last_name,
    customer.c_preferred_cust_flag AS customer_preferred_cust_flag,
    customer.c_birth_country AS customer_birth_country,
    customer.c_login AS customer_login,
    customer.c_email_address AS customer_email_address,
    date_dim.d_year AS dyear,
    SUM(
      (
        (
          (
            catalog_sales.cs_ext_list_price - catalog_sales.cs_ext_wholesale_cost - catalog_sales.cs_ext_discount_amt
          ) + catalog_sales.cs_ext_sales_price
        ) / 2
      )
    ) AS year_total,
    'c' AS sale_type
  FROM customer AS customer
  JOIN catalog_sales AS catalog_sales
    ON catalog_sales.cs_bill_customer_sk = customer.c_customer_sk
  JOIN date_dim AS date_dim
    ON catalog_sales.cs_sold_date_sk = date_dim.d_date_sk
  GROUP BY
    customer.c_customer_id,
    customer.c_first_name,
    customer.c_last_name,
    customer.c_preferred_cust_flag,
    customer.c_birth_country,
    customer.c_login,
    customer.c_email_address,
    date_dim.d_year
  UNION ALL
  SELECT
    customer.c_customer_id AS customer_id,
    customer.c_first_name AS customer_first_name,
    customer.c_last_name AS customer_last_name,
    customer.c_preferred_cust_flag AS customer_preferred_cust_flag,
    customer.c_birth_country AS customer_birth_country,
    customer.c_login AS customer_login,
    customer.c_email_address AS customer_email_address,
    date_dim.d_year AS dyear,
    SUM(
      (
        (
          (
            web_sales.ws_ext_list_price - web_sales.ws_ext_wholesale_cost - web_sales.ws_ext_discount_amt
          ) + web_sales.ws_ext_sales_price
        ) / 2
      )
    ) AS year_total,
    'w' AS sale_type
  FROM customer AS customer
  JOIN web_sales AS web_sales
    ON customer.c_customer_sk = web_sales.ws_bill_customer_sk
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = web_sales.ws_sold_date_sk
  GROUP BY
    customer.c_customer_id,
    customer.c_first_name,
    customer.c_last_name,
    customer.c_preferred_cust_flag,
    customer.c_birth_country,
    customer.c_login,
    customer.c_email_address,
    date_dim.d_year
)
SELECT
  t_s_secyear.customer_id AS customer_id,
  t_s_secyear.customer_first_name AS customer_first_name,
  t_s_secyear.customer_last_name AS customer_last_name,
  t_s_secyear.customer_preferred_cust_flag AS customer_preferred_cust_flag,
  t_s_secyear.customer_birth_country AS customer_birth_country,
  t_s_secyear.customer_login AS customer_login,
  t_s_secyear.customer_email_address AS customer_email_address
FROM year_total AS t_s_firstyear
JOIN year_total AS t_c_secyear
  ON t_c_secyear.customer_id = t_s_firstyear.customer_id
  AND t_c_secyear.dyear = 2002
  AND t_c_secyear.sale_type = 'c'
JOIN year_total AS t_s_secyear
  ON t_s_firstyear.customer_id = t_s_secyear.customer_id
  AND t_s_secyear.dyear = 2002
  AND t_s_secyear.sale_type = 's'
JOIN year_total AS t_w_firstyear
  ON t_s_firstyear.customer_id = t_w_firstyear.customer_id
  AND t_w_firstyear.dyear = 2001
  AND t_w_firstyear.sale_type = 'w'
  AND t_w_firstyear.year_total > 0
JOIN year_total AS t_w_secyear
  ON t_s_firstyear.customer_id = t_w_secyear.customer_id
  AND t_w_secyear.dyear = 2002
  AND t_w_secyear.sale_type = 'w'
JOIN year_total AS t_c_firstyear
  ON CASE
    WHEN t_c_firstyear.year_total > 0
    THEN t_c_secyear.year_total / t_c_firstyear.year_total
    ELSE NULL
  END > CASE
    WHEN t_s_firstyear.year_total > 0
    THEN t_s_secyear.year_total / t_s_firstyear.year_total
    ELSE NULL
  END
  AND CASE
    WHEN t_c_firstyear.year_total > 0
    THEN t_c_secyear.year_total / t_c_firstyear.year_total
    ELSE NULL
  END > CASE
    WHEN t_w_firstyear.year_total > 0
    THEN t_w_secyear.year_total / t_w_firstyear.year_total
    ELSE NULL
  END
  AND t_c_firstyear.customer_id = t_s_firstyear.customer_id
  AND t_c_firstyear.dyear = 2001
  AND t_c_firstyear.sale_type = 'c'
  AND t_c_firstyear.year_total > 0
WHERE
  t_s_firstyear.dyear = 2001
  AND t_s_firstyear.sale_type = 's'
  AND t_s_firstyear.year_total > 0
ORDER BY
  t_s_secyear.customer_id,
  t_s_secyear.customer_first_name,
  t_s_secyear.customer_last_name,
  t_s_secyear.customer_preferred_cust_flag,
  t_s_secyear.customer_birth_country,
  t_s_secyear.customer_login,
  t_s_secyear.customer_email_address
LIMIT 100