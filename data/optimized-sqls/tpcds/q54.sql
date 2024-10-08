WITH cs_or_ws_sales AS (
  SELECT
    catalog_sales.cs_sold_date_sk AS sold_date_sk,
    catalog_sales.cs_bill_customer_sk AS customer_sk,
    catalog_sales.cs_item_sk AS item_sk
  FROM catalog_sales AS catalog_sales
  UNION ALL
  SELECT
    web_sales.ws_sold_date_sk AS sold_date_sk,
    web_sales.ws_bill_customer_sk AS customer_sk,
    web_sales.ws_item_sk AS item_sk
  FROM web_sales AS web_sales
), my_customers AS (
  SELECT DISTINCT
    customer.c_customer_sk AS c_customer_sk,
    customer.c_current_addr_sk AS c_current_addr_sk
  FROM cs_or_ws_sales AS cs_or_ws_sales
  JOIN customer AS customer
    ON cs_or_ws_sales.customer_sk = customer.c_customer_sk
  JOIN date_dim AS date_dim
    ON cs_or_ws_sales.sold_date_sk = date_dim.d_date_sk
    AND date_dim.d_moy = 12
    AND date_dim.d_year = 1998
  JOIN item AS item
    ON cs_or_ws_sales.item_sk = item.i_item_sk
    AND item.i_category = 'Women'
    AND item.i_class = 'maternity'
), _u_0 AS (
  SELECT DISTINCT
    date_dim.d_month_seq + 1 AS _col_0
  FROM date_dim AS date_dim
  WHERE
    date_dim.d_moy = 12 AND date_dim.d_year = 1998
), _u_1 AS (
  SELECT DISTINCT
    date_dim.d_month_seq + 3 AS _col_0
  FROM date_dim AS date_dim
  WHERE
    date_dim.d_moy = 12 AND date_dim.d_year = 1998
), my_revenue AS (
  SELECT
    SUM(store_sales.ss_ext_sales_price) AS revenue
  FROM my_customers
  JOIN customer_address AS customer_address
    ON customer_address.ca_address_sk = my_customers.c_current_addr_sk
  JOIN store_sales AS store_sales
    ON my_customers.c_customer_sk = store_sales.ss_customer_sk
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = store_sales.ss_sold_date_sk
  JOIN store AS store
    ON customer_address.ca_county = store.s_county
    AND customer_address.ca_state = store.s_state
  JOIN _u_0 AS _u_0
    ON _u_0._col_0 <= date_dim.d_month_seq
  JOIN _u_1 AS _u_1
    ON _u_1._col_0 >= date_dim.d_month_seq
  GROUP BY
    my_customers.c_customer_sk
)
SELECT
  CAST((
    my_revenue.revenue / 50
  ) AS INT) AS segment,
  COUNT(*) AS num_customers,
  CAST((
    my_revenue.revenue / 50
  ) AS INT) * 50 AS segment_base
FROM my_revenue
GROUP BY
  CAST((
    my_revenue.revenue / 50
  ) AS INT)
ORDER BY
  segment,
  num_customers
LIMIT 100