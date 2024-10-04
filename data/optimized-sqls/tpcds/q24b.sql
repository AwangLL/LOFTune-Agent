WITH ssales AS (
  SELECT
    customer.c_last_name AS c_last_name,
    customer.c_first_name AS c_first_name,
    store.s_store_name AS s_store_name,
    item.i_color AS i_color,
    SUM(store_sales.ss_net_paid) AS netpaid
  FROM store_sales AS store_sales
  JOIN item AS item
    ON item.i_item_sk = store_sales.ss_item_sk
  JOIN store AS store
    ON store.s_market_id = 8 AND store.s_store_sk = store_sales.ss_store_sk
  JOIN store_returns AS store_returns
    ON store_returns.sr_item_sk = store_sales.ss_item_sk
    AND store_returns.sr_ticket_number = store_sales.ss_ticket_number
  JOIN customer_address AS customer_address
    ON customer_address.ca_zip = store.s_zip
  JOIN customer AS customer
    ON customer.c_birth_country = UPPER(customer_address.ca_country)
    AND customer.c_customer_sk = store_sales.ss_customer_sk
  GROUP BY
    customer.c_last_name,
    customer.c_first_name,
    store.s_store_name,
    customer_address.ca_state,
    store.s_state,
    item.i_color,
    item.i_current_price,
    item.i_manager_id,
    item.i_units,
    item.i_size
), _u_0 AS (
  SELECT
    0.05 * AVG(ssales.netpaid) AS _col_0
  FROM ssales
)
SELECT
  ssales.c_last_name AS c_last_name,
  ssales.c_first_name AS c_first_name,
  ssales.s_store_name AS s_store_name,
  SUM(ssales.netpaid) AS paid
FROM ssales
CROSS JOIN _u_0 AS _u_0
WHERE
  ssales.i_color = 'chiffon'
GROUP BY
  ssales.c_last_name,
  ssales.c_first_name,
  ssales.s_store_name
HAVING
  MAX(_u_0._col_0) < SUM(ssales.netpaid)