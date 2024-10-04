WITH ws_wh AS (
  SELECT
    ws1.ws_order_number AS ws_order_number
  FROM web_sales AS ws1
  JOIN web_sales AS ws2
    ON ws1.ws_order_number = ws2.ws_order_number
    AND ws1.ws_warehouse_sk <> ws2.ws_warehouse_sk
), _u_0 AS (
  SELECT
    ws_wh.ws_order_number AS ws_order_number
  FROM ws_wh
  GROUP BY
    ws_wh.ws_order_number
), _u_1 AS (
  SELECT
    web_returns.wr_order_number AS wr_order_number
  FROM web_returns AS web_returns
  JOIN ws_wh
    ON web_returns.wr_order_number = ws_wh.ws_order_number
  GROUP BY
    web_returns.wr_order_number
)
SELECT
  COUNT(DISTINCT ws1.ws_order_number) AS `order count `,
  SUM(ws1.ws_ext_ship_cost) AS `total shipping cost `,
  SUM(ws1.ws_net_profit) AS `total net profit `
FROM web_sales AS ws1
LEFT JOIN _u_0 AS _u_0
  ON `_u_0`.`ws_order_number` = ws1.ws_order_number
LEFT JOIN _u_1 AS _u_1
  ON `_u_1`.`wr_order_number` = ws1.ws_order_number
JOIN customer_address AS customer_address
  ON customer_address.ca_address_sk = ws1.ws_ship_addr_sk
  AND customer_address.ca_state <> 'IL'
JOIN date_dim AS date_dim
  ON date_dim.d_date > CAST('1998-02-01' AS DATE)
  AND date_dim.d_date_sk = ws1.ws_ship_date_sk
JOIN web_site AS web_site
  ON web_site.web_company_name <> 'pri' AND web_site.web_site_sk = ws1.ws_web_site_sk
WHERE
  NOT `_u_0`.`ws_order_number` IS NULL AND NOT `_u_1`.`wr_order_number` IS NULL
ORDER BY
  COUNT(DISTINCT ws1.ws_order_number)
LIMIT 100