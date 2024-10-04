WITH cool_cust AS (
  (
    SELECT DISTINCT
      customer.c_last_name AS c_last_name,
      customer.c_first_name AS c_first_name,
      date_dim.d_date AS d_date
    FROM store_sales AS store_sales
    JOIN customer AS customer
      ON customer.c_customer_sk = store_sales.ss_customer_sk
    JOIN date_dim AS date_dim
      ON date_dim.d_date_sk = store_sales.ss_sold_date_sk
      AND date_dim.d_month_seq <= 1211
      AND date_dim.d_month_seq >= 1200
  )
  EXCEPT
  (
    SELECT DISTINCT
      customer.c_last_name AS c_last_name,
      customer.c_first_name AS c_first_name,
      date_dim.d_date AS d_date
    FROM catalog_sales AS catalog_sales
    JOIN customer AS customer
      ON catalog_sales.cs_bill_customer_sk = customer.c_customer_sk
    JOIN date_dim AS date_dim
      ON catalog_sales.cs_sold_date_sk = date_dim.d_date_sk
      AND date_dim.d_month_seq <= 1211
      AND date_dim.d_month_seq >= 1200
  )
  EXCEPT
  (
    SELECT DISTINCT
      customer.c_last_name AS c_last_name,
      customer.c_first_name AS c_first_name,
      date_dim.d_date AS d_date
    FROM web_sales AS web_sales
    JOIN customer AS customer
      ON customer.c_customer_sk = web_sales.ws_bill_customer_sk
    JOIN date_dim AS date_dim
      ON date_dim.d_date_sk = web_sales.ws_sold_date_sk
      AND date_dim.d_month_seq <= 1211
      AND date_dim.d_month_seq >= 1200
  )
)
SELECT
  COUNT(*) AS _col_0
FROM cool_cust AS cool_cust