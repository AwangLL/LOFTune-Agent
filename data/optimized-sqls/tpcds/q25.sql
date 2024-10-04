SELECT
  item.i_item_id AS i_item_id,
  item.i_item_desc AS i_item_desc,
  store.s_store_id AS s_store_id,
  store.s_store_name AS s_store_name,
  SUM(store_sales.ss_net_profit) AS store_sales_profit,
  SUM(store_returns.sr_net_loss) AS store_returns_loss,
  SUM(catalog_sales.cs_net_profit) AS catalog_sales_profit
FROM store_sales AS store_sales
JOIN date_dim AS d1
  ON d1.d_date_sk = store_sales.ss_sold_date_sk AND d1.d_moy = 4 AND d1.d_year = 2001
JOIN item AS item
  ON item.i_item_sk = store_sales.ss_item_sk
JOIN store AS store
  ON store.s_store_sk = store_sales.ss_store_sk
JOIN store_returns AS store_returns
  ON store_returns.sr_customer_sk = store_sales.ss_customer_sk
  AND store_returns.sr_item_sk = store_sales.ss_item_sk
  AND store_returns.sr_ticket_number = store_sales.ss_ticket_number
JOIN catalog_sales AS catalog_sales
  ON catalog_sales.cs_bill_customer_sk = store_returns.sr_customer_sk
  AND catalog_sales.cs_item_sk = store_returns.sr_item_sk
JOIN date_dim AS d2
  ON d2.d_date_sk = store_returns.sr_returned_date_sk
  AND d2.d_moy <= 10
  AND d2.d_moy >= 4
  AND d2.d_year = 2001
JOIN date_dim AS d3
  ON catalog_sales.cs_sold_date_sk = d3.d_date_sk
  AND d3.d_moy <= 10
  AND d3.d_moy >= 4
  AND d3.d_year = 2001
GROUP BY
  item.i_item_id,
  item.i_item_desc,
  store.s_store_id,
  store.s_store_name
ORDER BY
  i_item_id,
  i_item_desc,
  s_store_id,
  s_store_name
LIMIT 100