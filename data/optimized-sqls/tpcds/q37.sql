SELECT
  item.i_item_id AS i_item_id,
  item.i_item_desc AS i_item_desc,
  item.i_current_price AS i_current_price
FROM item AS item
JOIN catalog_sales AS catalog_sales
  ON catalog_sales.cs_item_sk = item.i_item_sk
JOIN inventory AS inventory
  ON inventory.inv_item_sk = item.i_item_sk
  AND inventory.inv_quantity_on_hand <= 500
  AND inventory.inv_quantity_on_hand >= 100
JOIN date_dim AS date_dim
  ON date_dim.d_date <= (
    CAST('2000-04-01' AS DATE)
  )
  AND date_dim.d_date >= CAST('2000-02-01' AS DATE)
  AND date_dim.d_date_sk = inventory.inv_date_sk
WHERE
  item.i_current_price <= 98
  AND item.i_current_price >= 68
  AND item.i_manufact_id IN (677, 694, 808, 940)
GROUP BY
  item.i_item_id,
  item.i_item_desc,
  item.i_current_price
ORDER BY
  i_item_id
LIMIT 100