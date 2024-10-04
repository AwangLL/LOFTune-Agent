SELECT
  warehouse.w_state AS w_state,
  item.i_item_id AS i_item_id,
  SUM(
    CASE
      WHEN CAST(date_dim.d_date AS DATE) < CAST('2000-03-11' AS DATE)
      THEN catalog_sales.cs_sales_price - COALESCE(catalog_returns.cr_refunded_cash, 0)
      ELSE 0
    END
  ) AS sales_before,
  SUM(
    CASE
      WHEN CAST(date_dim.d_date AS DATE) >= CAST('2000-03-11' AS DATE)
      THEN catalog_sales.cs_sales_price - COALESCE(catalog_returns.cr_refunded_cash, 0)
      ELSE 0
    END
  ) AS sales_after
FROM catalog_sales AS catalog_sales
LEFT JOIN catalog_returns AS catalog_returns
  ON catalog_returns.cr_item_sk = catalog_sales.cs_item_sk
  AND catalog_returns.cr_order_number = catalog_sales.cs_order_number
JOIN date_dim AS date_dim
  ON catalog_sales.cs_sold_date_sk = date_dim.d_date_sk
  AND date_dim.d_date <= (
    CAST('2000-04-10' AS DATE)
  )
  AND date_dim.d_date >= (
    CAST('2000-02-10' AS DATE)
  )
JOIN item AS item
  ON catalog_sales.cs_item_sk = item.i_item_sk
  AND item.i_current_price <= 1.49
  AND item.i_current_price >= 0.99
JOIN warehouse AS warehouse
  ON catalog_sales.cs_warehouse_sk = warehouse.w_warehouse_sk
GROUP BY
  warehouse.w_state,
  item.i_item_id
ORDER BY
  w_state,
  i_item_id
LIMIT 100