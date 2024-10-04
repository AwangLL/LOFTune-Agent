WITH _u_0 AS (
  SELECT
    item.i_manufact_id AS i_manufact_id
  FROM item AS item
  WHERE
    item.i_category IN ('Electronics')
  GROUP BY
    item.i_manufact_id
), ss AS (
  SELECT
    item.i_manufact_id AS i_manufact_id,
    SUM(store_sales.ss_ext_sales_price) AS total_sales
  FROM store_sales AS store_sales
  JOIN customer_address AS customer_address
    ON customer_address.ca_address_sk = store_sales.ss_addr_sk
    AND customer_address.ca_gmt_offset = -5
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = store_sales.ss_sold_date_sk
    AND date_dim.d_moy = 5
    AND date_dim.d_year = 1998
  JOIN item AS item
    ON item.i_item_sk = store_sales.ss_item_sk
  LEFT JOIN _u_0 AS _u_0
    ON `_u_0`.`i_manufact_id` = item.i_manufact_id
  WHERE
    NOT `_u_0`.`i_manufact_id` IS NULL
  GROUP BY
    item.i_manufact_id
), cs AS (
  SELECT
    item.i_manufact_id AS i_manufact_id,
    SUM(catalog_sales.cs_ext_sales_price) AS total_sales
  FROM catalog_sales AS catalog_sales
  JOIN customer_address AS customer_address
    ON catalog_sales.cs_bill_addr_sk = customer_address.ca_address_sk
    AND customer_address.ca_gmt_offset = -5
  JOIN date_dim AS date_dim
    ON catalog_sales.cs_sold_date_sk = date_dim.d_date_sk
    AND date_dim.d_moy = 5
    AND date_dim.d_year = 1998
  JOIN item AS item
    ON catalog_sales.cs_item_sk = item.i_item_sk
  LEFT JOIN _u_0 AS _u_1
    ON `_u_1`.`i_manufact_id` = item.i_manufact_id
  WHERE
    NOT `_u_1`.`i_manufact_id` IS NULL
  GROUP BY
    item.i_manufact_id
), ws AS (
  SELECT
    item.i_manufact_id AS i_manufact_id,
    SUM(web_sales.ws_ext_sales_price) AS total_sales
  FROM web_sales AS web_sales
  JOIN customer_address AS customer_address
    ON customer_address.ca_address_sk = web_sales.ws_bill_addr_sk
    AND customer_address.ca_gmt_offset = -5
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = web_sales.ws_sold_date_sk
    AND date_dim.d_moy = 5
    AND date_dim.d_year = 1998
  JOIN item AS item
    ON item.i_item_sk = web_sales.ws_item_sk
  LEFT JOIN _u_0 AS _u_2
    ON `_u_2`.`i_manufact_id` = item.i_manufact_id
  WHERE
    NOT `_u_2`.`i_manufact_id` IS NULL
  GROUP BY
    item.i_manufact_id
), tmp1 AS (
  SELECT
    ss.i_manufact_id AS i_manufact_id,
    ss.total_sales AS total_sales
  FROM ss
  UNION ALL
  SELECT
    cs.i_manufact_id AS i_manufact_id,
    cs.total_sales AS total_sales
  FROM cs
  UNION ALL
  SELECT
    ws.i_manufact_id AS i_manufact_id,
    ws.total_sales AS total_sales
  FROM ws
)
SELECT
  tmp1.i_manufact_id AS i_manufact_id,
  SUM(tmp1.total_sales) AS total_sales
FROM tmp1 AS tmp1
GROUP BY
  tmp1.i_manufact_id
ORDER BY
  total_sales
LIMIT 100