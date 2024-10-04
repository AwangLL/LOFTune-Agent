WITH _u_3 AS (
  SELECT
    wr1.wr_order_number AS _u_4
  FROM web_returns AS wr1
  GROUP BY
    wr1.wr_order_number
)
SELECT
  COUNT(DISTINCT ws1.ws_order_number) AS `order count `,
  SUM(ws1.ws_ext_ship_cost) AS `total shipping cost `,
  SUM(ws1.ws_net_profit) AS `total net profit `
FROM web_sales AS ws1
LEFT JOIN _u_3 AS _u_3
  ON _u_3._u_4 = ws1.ws_order_number
JOIN customer_address AS customer_address
  ON customer_address.ca_address_sk = ws1.ws_ship_addr_sk
  AND customer_address.ca_state = 'IL'
JOIN date_dim AS date_dim
  ON date_dim.d_date <= (
    CAST('1999-04-02' AS DATE)
  )
  AND date_dim.d_date >= '1999-02-01'
  AND date_dim.d_date_sk = ws1.ws_ship_date_sk
JOIN web_site AS web_site
  ON web_site.web_company_name = 'pri' AND web_site.web_site_sk = ws1.ws_web_site_sk
WHERE
  _u_3._u_4 IS NULL
  AND EXISTS(
    SELECT
      *
    FROM web_sales AS ws2
    WHERE
      ws1.ws_order_number = ws2.ws_order_number
      AND ws1.ws_warehouse_sk <> ws2.ws_warehouse_sk
  )
ORDER BY
  COUNT(DISTINCT ws1.ws_order_number)
LIMIT 100