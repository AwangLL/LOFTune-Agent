WITH _u_0 AS (
  SELECT
    1.3 * AVG(web_sales.ws_ext_discount_amt) AS _col_0,
    web_sales.ws_item_sk AS _u_1
  FROM web_sales AS web_sales
  JOIN date_dim AS date_dim
    ON date_dim.d_date <= (
      CAST('2000-04-26' AS DATE)
    )
    AND date_dim.d_date >= '2000-01-27'
    AND date_dim.d_date_sk = web_sales.ws_sold_date_sk
  GROUP BY
    web_sales.ws_item_sk
)
SELECT
  SUM(web_sales.ws_ext_discount_amt) AS `excess discount amount `
FROM web_sales AS web_sales
JOIN date_dim AS date_dim
  ON date_dim.d_date <= (
    CAST('2000-04-26' AS DATE)
  )
  AND date_dim.d_date >= '2000-01-27'
  AND date_dim.d_date_sk = web_sales.ws_sold_date_sk
JOIN item AS item
  ON item.i_item_sk = web_sales.ws_item_sk AND item.i_manufact_id = 350
LEFT JOIN _u_0 AS _u_0
  ON _u_0._u_1 = item.i_item_sk
WHERE
  _u_0._col_0 < web_sales.ws_ext_discount_amt
ORDER BY
  SUM(web_sales.ws_ext_discount_amt)
LIMIT 100