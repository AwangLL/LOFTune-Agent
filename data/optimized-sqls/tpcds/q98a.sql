SELECT
  item.i_item_desc AS i_item_desc,
  item.i_category AS i_category,
  item.i_class AS i_class,
  item.i_current_price AS i_current_price,
  SUM(store_sales.ss_ext_sales_price) AS itemrevenue,
  SUM(store_sales.ss_ext_sales_price) * 100 / SUM(SUM(store_sales.ss_ext_sales_price)) OVER (PARTITION BY item.i_class) AS revenueratio
FROM store_sales AS store_sales
JOIN date_dim AS date_dim
  ON date_dim.d_date <= (
    CAST('1999-05-21' AS DATE)
  )
  AND date_dim.d_date >= CAST('1998-02-22' AS DATE)
  AND date_dim.d_date_sk = store_sales.ss_sold_date_sk
JOIN item AS item
  ON item.i_category IN ('Children', 'Jewelry', 'Men', 'Shoes')
  AND item.i_item_sk = store_sales.ss_item_sk
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