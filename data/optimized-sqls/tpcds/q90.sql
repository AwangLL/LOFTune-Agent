WITH at AS (
  SELECT
    COUNT(*) AS amc
  FROM web_sales AS web_sales
  JOIN household_demographics AS household_demographics
    ON household_demographics.hd_demo_sk = web_sales.ws_ship_hdemo_sk
    AND household_demographics.hd_dep_count = 6
  JOIN time_dim AS time_dim
    ON time_dim.t_hour <= 9
    AND time_dim.t_hour >= 8
    AND time_dim.t_time_sk = web_sales.ws_sold_time_sk
  JOIN web_page AS web_page
    ON web_page.wp_char_count <= 5200
    AND web_page.wp_char_count >= 5000
    AND web_page.wp_web_page_sk = web_sales.ws_web_page_sk
), pt AS (
  SELECT
    COUNT(*) AS pmc
  FROM web_sales AS web_sales
  JOIN household_demographics AS household_demographics
    ON household_demographics.hd_demo_sk = web_sales.ws_ship_hdemo_sk
    AND household_demographics.hd_dep_count = 6
  JOIN time_dim AS time_dim
    ON time_dim.t_hour <= 20
    AND time_dim.t_hour >= 19
    AND time_dim.t_time_sk = web_sales.ws_sold_time_sk
  JOIN web_page AS web_page
    ON web_page.wp_char_count <= 5200
    AND web_page.wp_char_count >= 5000
    AND web_page.wp_web_page_sk = web_sales.ws_web_page_sk
)
SELECT
  CAST(at.amc AS DECIMAL(15, 4)) / CAST(pt.pmc AS DECIMAL(15, 4)) AS am_pm_ratio
FROM at AS at
CROSS JOIN pt AS pt
ORDER BY
  am_pm_ratio
LIMIT 100