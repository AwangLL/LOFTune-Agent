WITH year_total AS (
  SELECT
    customer.c_customer_id AS customer_id,
    customer.c_preferred_cust_flag AS customer_preferred_cust_flag,
    date_dim.d_year AS dyear,
    SUM(store_sales.ss_ext_list_price - store_sales.ss_ext_discount_amt) AS year_total,
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
    date_dim.d_year,
    customer.c_preferred_cust_flag,
    customer.c_birth_country,
    customer.c_login,
    customer.c_email_address,
    date_dim.d_year
  UNION ALL
  SELECT
    customer.c_customer_id AS customer_id,
    customer.c_preferred_cust_flag AS customer_preferred_cust_flag,
    date_dim.d_year AS dyear,
    SUM(web_sales.ws_ext_list_price - web_sales.ws_ext_discount_amt) AS year_total,
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
  t_s_secyear.customer_preferred_cust_flag AS customer_preferred_cust_flag
FROM year_total AS t_s_firstyear
JOIN year_total AS t_w_firstyear
  ON t_s_firstyear.customer_id = t_w_firstyear.customer_id
  AND t_w_firstyear.dyear = 2001
  AND t_w_firstyear.sale_type = 'w'
  AND t_w_firstyear.year_total > 0
JOIN year_total AS t_w_secyear
  ON t_s_firstyear.customer_id = t_w_secyear.customer_id
  AND t_w_secyear.dyear = 2002
  AND t_w_secyear.sale_type = 'w'
JOIN year_total AS t_s_secyear
  ON CASE
    WHEN t_s_firstyear.year_total > 0
    THEN t_s_secyear.year_total / t_s_firstyear.year_total
    ELSE NULL
  END < CASE
    WHEN t_w_firstyear.year_total > 0
    THEN t_w_secyear.year_total / t_w_firstyear.year_total
    ELSE NULL
  END
  AND t_s_firstyear.customer_id = t_s_secyear.customer_id
  AND t_s_secyear.dyear = 2002
  AND t_s_secyear.sale_type = 's'
WHERE
  t_s_firstyear.dyear = 2001
  AND t_s_firstyear.sale_type = 's'
  AND t_s_firstyear.year_total > 0
ORDER BY
  t_s_secyear.customer_preferred_cust_flag
LIMIT 100