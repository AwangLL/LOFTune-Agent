SELECT
  SUBSTR(warehouse.w_warehouse_name, 1, 20) AS _col_0,
  ship_mode.sm_type AS sm_type,
  web_site.web_name AS web_name,
  SUM(
    CASE
      WHEN web_sales.ws_ship_date_sk - web_sales.ws_sold_date_sk <= 30
      THEN 1
      ELSE 0
    END
  ) AS `30 days `,
  SUM(
    CASE
      WHEN web_sales.ws_ship_date_sk - web_sales.ws_sold_date_sk <= 60
      AND web_sales.ws_ship_date_sk - web_sales.ws_sold_date_sk > 30
      THEN 1
      ELSE 0
    END
  ) AS `31 - 60 days `,
  SUM(
    CASE
      WHEN web_sales.ws_ship_date_sk - web_sales.ws_sold_date_sk <= 90
      AND web_sales.ws_ship_date_sk - web_sales.ws_sold_date_sk > 60
      THEN 1
      ELSE 0
    END
  ) AS `61 - 90 days `,
  SUM(
    CASE
      WHEN web_sales.ws_ship_date_sk - web_sales.ws_sold_date_sk <= 120
      AND web_sales.ws_ship_date_sk - web_sales.ws_sold_date_sk > 90
      THEN 1
      ELSE 0
    END
  ) AS `91 - 120 days `,
  SUM(
    CASE
      WHEN web_sales.ws_ship_date_sk - web_sales.ws_sold_date_sk > 120
      THEN 1
      ELSE 0
    END
  ) AS `>120 days `
FROM web_sales AS web_sales
JOIN date_dim AS date_dim
  ON date_dim.d_date_sk = web_sales.ws_ship_date_sk
  AND date_dim.d_month_seq <= 1211
  AND date_dim.d_month_seq >= 1200
JOIN ship_mode AS ship_mode
  ON ship_mode.sm_ship_mode_sk = web_sales.ws_ship_mode_sk
JOIN warehouse AS warehouse
  ON warehouse.w_warehouse_sk = web_sales.ws_warehouse_sk
JOIN web_site AS web_site
  ON web_sales.ws_web_site_sk = web_site.web_site_sk
GROUP BY
  SUBSTR(warehouse.w_warehouse_name, 1, 20),
  ship_mode.sm_type,
  web_site.web_name
ORDER BY
  _col_0,
  sm_type,
  web_name
LIMIT 100