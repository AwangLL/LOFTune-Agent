WITH x AS (
  SELECT
    warehouse.w_warehouse_name AS w_warehouse_name,
    item.i_item_id AS i_item_id,
    SUM(
      CASE
        WHEN CAST(date_dim.d_date AS DATE) < CAST('2000-03-11' AS DATE)
        THEN inventory.inv_quantity_on_hand
        ELSE 0
      END
    ) AS inv_before,
    SUM(
      CASE
        WHEN CAST(date_dim.d_date AS DATE) >= CAST('2000-03-11' AS DATE)
        THEN inventory.inv_quantity_on_hand
        ELSE 0
      END
    ) AS inv_after
  FROM inventory AS inventory
  JOIN date_dim AS date_dim
    ON date_dim.d_date <= (
      CAST('2000-04-10' AS DATE)
    )
    AND date_dim.d_date >= (
      CAST('2000-02-10' AS DATE)
    )
    AND date_dim.d_date_sk = inventory.inv_date_sk
  JOIN item AS item
    ON inventory.inv_item_sk = item.i_item_sk
    AND item.i_current_price <= 1.49
    AND item.i_current_price >= 0.99
  JOIN warehouse AS warehouse
    ON inventory.inv_warehouse_sk = warehouse.w_warehouse_sk
  GROUP BY
    warehouse.w_warehouse_name,
    item.i_item_id
)
SELECT
  x.w_warehouse_name AS w_warehouse_name,
  x.i_item_id AS i_item_id,
  x.inv_before AS inv_before,
  x.inv_after AS inv_after
FROM x AS x
WHERE
  CASE WHEN x.inv_before > 0 THEN x.inv_after / x.inv_before ELSE NULL END <= 1.5
  AND CASE WHEN x.inv_before > 0 THEN x.inv_after / x.inv_before ELSE NULL END >= 0.6666666666666666666666666667
ORDER BY
  x.w_warehouse_name,
  x.i_item_id
LIMIT 100