WITH _u_3 AS (
  SELECT
    cr1.cr_order_number AS _u_4
  FROM catalog_returns AS cr1
  GROUP BY
    cr1.cr_order_number
)
SELECT
  COUNT(DISTINCT cs1.cs_order_number) AS `order count `,
  SUM(cs1.cs_ext_ship_cost) AS `total shipping cost `,
  SUM(cs1.cs_net_profit) AS `total net profit `
FROM catalog_sales AS cs1
LEFT JOIN _u_3 AS _u_3
  ON _u_3._u_4 = cs1.cs_order_number
JOIN call_center AS call_center
  ON call_center.cc_call_center_sk = cs1.cs_call_center_sk
  AND call_center.cc_county IN ('Williamson County')
JOIN customer_address AS customer_address
  ON cs1.cs_ship_addr_sk = customer_address.ca_address_sk
  AND customer_address.ca_state = 'GA'
JOIN date_dim AS date_dim
  ON cs1.cs_ship_date_sk = date_dim.d_date_sk
  AND date_dim.d_date <= (
    CAST('2002-04-02' AS DATE)
  )
  AND date_dim.d_date >= '2002-02-01'
WHERE
  _u_3._u_4 IS NULL
  AND EXISTS(
    SELECT
      *
    FROM catalog_sales AS cs2
    WHERE
      cs1.cs_order_number = cs2.cs_order_number
      AND cs1.cs_warehouse_sk <> cs2.cs_warehouse_sk
  )
ORDER BY
  COUNT(DISTINCT cs1.cs_order_number)
LIMIT 100