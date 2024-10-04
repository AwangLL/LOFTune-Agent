WITH _u_0 AS (
  SELECT
    1.3 * AVG(catalog_sales.cs_ext_discount_amt) AS _col_0,
    catalog_sales.cs_item_sk AS _u_1
  FROM catalog_sales AS catalog_sales
  JOIN date_dim AS date_dim
    ON catalog_sales.cs_sold_date_sk = date_dim.d_date_sk
    AND date_dim.d_date <= (
      CAST('2000-04-26' AS DATE)
    )
    AND date_dim.d_date >= '2000-01-27'
  GROUP BY
    catalog_sales.cs_item_sk
)
SELECT
  1 AS `excess discount amount `
FROM catalog_sales AS catalog_sales
JOIN date_dim AS date_dim
  ON catalog_sales.cs_sold_date_sk = date_dim.d_date_sk
  AND date_dim.d_date <= (
    CAST('2000-04-26' AS DATE)
  )
  AND date_dim.d_date >= '2000-01-27'
JOIN item AS item
  ON catalog_sales.cs_item_sk = item.i_item_sk AND item.i_manufact_id = 977
LEFT JOIN _u_0 AS _u_0
  ON _u_0._u_1 = item.i_item_sk
WHERE
  _u_0._col_0 < catalog_sales.cs_ext_discount_amt
LIMIT 100