SELECT
  item.i_item_id AS i_item_id,
  item.i_item_desc AS i_item_desc,
  item.i_current_price AS i_current_price
FROM item AS item
JOIN inventory AS inventory
  ON inventory.inv_item_sk = item.i_item_sk
  AND inventory.inv_quantity_on_hand <= 500
  AND inventory.inv_quantity_on_hand >= 100
JOIN store_sales AS store_sales
  ON item.i_item_sk = store_sales.ss_item_sk
JOIN date_dim AS date_dim
  ON date_dim.d_date <= (
    CAST('2000-07-24' AS DATE)
  )
  AND date_dim.d_date >= CAST('2000-05-25' AS DATE)
  AND date_dim.d_date_sk = inventory.inv_date_sk
WHERE
  item.i_current_price <= 92
  AND item.i_current_price >= 62
  AND item.i_manufact_id IN (129, 270, 423, 821)
GROUP BY
  item.i_item_id,
  item.i_item_desc,
  item.i_current_price
ORDER BY
  i_item_id
LIMIT 100