SELECT
  SUBSTR(reason.r_reason_desc, 1, 20) AS _col_0,
  AVG(web_sales.ws_quantity) AS _col_1,
  AVG(web_returns.wr_refunded_cash) AS _col_2,
  AVG(web_returns.wr_fee) AS _col_3
FROM web_sales AS web_sales
JOIN date_dim AS date_dim
  ON date_dim.d_date_sk = web_sales.ws_sold_date_sk AND date_dim.d_year = 2000
JOIN web_page AS web_page
  ON web_page.wp_web_page_sk = web_sales.ws_web_page_sk
JOIN web_returns AS web_returns
  ON web_returns.wr_item_sk = web_sales.ws_item_sk
  AND web_returns.wr_order_number = web_sales.ws_order_number
JOIN customer_demographics AS cd2
  ON cd2.cd_demo_sk = web_returns.wr_returning_cdemo_sk
JOIN customer_address AS customer_address
  ON (
    (
      customer_address.ca_country = 'United States'
      AND customer_address.ca_state IN ('IN', 'NJ', 'OH')
      AND web_sales.ws_net_profit <= 200
      AND web_sales.ws_net_profit >= 100
    )
    OR (
      customer_address.ca_country = 'United States'
      AND customer_address.ca_state IN ('AR', 'IA', 'LA')
      AND web_sales.ws_net_profit <= 250
      AND web_sales.ws_net_profit >= 50
    )
    OR (
      customer_address.ca_country = 'United States'
      AND customer_address.ca_state IN ('CT', 'KY', 'WI')
      AND web_sales.ws_net_profit <= 300
      AND web_sales.ws_net_profit >= 150
    )
  )
  AND customer_address.ca_address_sk = web_returns.wr_refunded_addr_sk
JOIN reason AS reason
  ON reason.r_reason_sk = web_returns.wr_reason_sk
JOIN customer_demographics AS cd1
  ON (
    (
      cd1.cd_education_status = '2 yr Degree'
      AND cd1.cd_education_status = cd2.cd_education_status
      AND cd1.cd_marital_status = 'W'
      AND cd1.cd_marital_status = cd2.cd_marital_status
      AND web_sales.ws_sales_price <= 200.00
      AND web_sales.ws_sales_price >= 150.00
    )
    OR (
      cd1.cd_education_status = 'Advanced Degree'
      AND cd1.cd_education_status = cd2.cd_education_status
      AND cd1.cd_marital_status = 'M'
      AND cd1.cd_marital_status = cd2.cd_marital_status
      AND web_sales.ws_sales_price <= 150.00
      AND web_sales.ws_sales_price >= 100.00
    )
    OR (
      cd1.cd_education_status = 'College'
      AND cd1.cd_education_status = cd2.cd_education_status
      AND cd1.cd_marital_status = 'S'
      AND cd1.cd_marital_status = cd2.cd_marital_status
      AND web_sales.ws_sales_price <= 100.00
      AND web_sales.ws_sales_price >= 50.00
    )
  )
  AND cd1.cd_demo_sk = web_returns.wr_refunded_cdemo_sk
GROUP BY
  reason.r_reason_desc
ORDER BY
  _col_0,
  _col_1,
  _col_2,
  _col_3
LIMIT 100