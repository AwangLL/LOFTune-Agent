SELECT
  item.i_item_desc AS i_item_desc,
  item.i_category AS i_category,
  item.i_class AS i_class,
  item.i_current_price AS i_current_price,
  SUM(web_sales.ws_ext_sales_price) AS itemrevenue,
  SUM(web_sales.ws_ext_sales_price) * 100 / SUM(SUM(web_sales.ws_ext_sales_price)) OVER (PARTITION BY item.i_class) AS revenueratio
FROM web_sales AS web_sales
JOIN date_dim AS date_dim
  ON date_dim.d_date <= (
    CAST('1999-03-24' AS DATE)
  )
  AND date_dim.d_date >= CAST('1999-02-22' AS DATE)
  AND date_dim.d_date_sk = web_sales.ws_sold_date_sk
JOIN item AS item
  ON item.i_category IN ('Books', 'Home', 'Sports')
  AND item.i_item_sk = web_sales.ws_item_sk
GROUP BY
  item.i_item_id,
  item.i_item_desc,
  item.i_category,
  item.i_class,
  item.i_current_price
ORDER BY
  i_category,
  i_class,
  item.i_item_id,
  i_item_desc,
  revenueratio
LIMIT 100