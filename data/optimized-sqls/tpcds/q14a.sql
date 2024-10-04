WITH x AS (
  SELECT
    iss.i_brand_id AS brand_id,
    iss.i_class_id AS class_id,
    iss.i_category_id AS category_id
  FROM store_sales AS store_sales
  JOIN date_dim AS d1
    ON d1.d_date_sk = store_sales.ss_sold_date_sk AND d1.d_year <= 2001 AND d1.d_year >= 1999
  JOIN item AS iss
    ON iss.i_item_sk = store_sales.ss_item_sk
  INTERSECT
  SELECT
    ics.i_brand_id AS i_brand_id,
    ics.i_class_id AS i_class_id,
    ics.i_category_id AS i_category_id
  FROM catalog_sales AS catalog_sales
  JOIN date_dim AS d2
    ON catalog_sales.cs_sold_date_sk = d2.d_date_sk AND d2.d_year <= 2001 AND d2.d_year >= 1999
  JOIN item AS ics
    ON catalog_sales.cs_item_sk = ics.i_item_sk
  INTERSECT
  SELECT
    iws.i_brand_id AS i_brand_id,
    iws.i_class_id AS i_class_id,
    iws.i_category_id AS i_category_id
  FROM web_sales AS web_sales
  JOIN date_dim AS d3
    ON d3.d_date_sk = web_sales.ws_sold_date_sk AND d3.d_year <= 2001 AND d3.d_year >= 1999
  JOIN item AS iws
    ON iws.i_item_sk = web_sales.ws_item_sk
), x_2 AS (
  SELECT
    store_sales.ss_quantity AS quantity,
    store_sales.ss_list_price AS list_price
  FROM store_sales AS store_sales
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = store_sales.ss_sold_date_sk
    AND date_dim.d_year <= 2001
    AND date_dim.d_year >= 1999
  UNION ALL
  SELECT
    catalog_sales.cs_quantity AS quantity,
    catalog_sales.cs_list_price AS list_price
  FROM catalog_sales AS catalog_sales
  JOIN date_dim AS date_dim
    ON catalog_sales.cs_sold_date_sk = date_dim.d_date_sk
    AND date_dim.d_year <= 2001
    AND date_dim.d_year >= 1999
  UNION ALL
  SELECT
    web_sales.ws_quantity AS quantity,
    web_sales.ws_list_price AS list_price
  FROM web_sales AS web_sales
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = web_sales.ws_sold_date_sk
    AND date_dim.d_year <= 2001
    AND date_dim.d_year >= 1999
), avg_sales AS (
  SELECT
    AVG(x.quantity * x.list_price) AS average_sales
  FROM x_2 AS x
), _u_1 AS (
  SELECT
    avg_sales.average_sales AS average_sales
  FROM avg_sales
), _u_0 AS (
  SELECT
    item.i_item_sk AS ss_item_sk
  FROM item AS item
  JOIN x AS x
    ON item.i_brand_id = x.brand_id
    AND item.i_category_id = x.category_id
    AND item.i_class_id = x.class_id
  GROUP BY
    item.i_item_sk
), y AS (
  SELECT
    'store' AS channel,
    item.i_brand_id AS i_brand_id,
    item.i_class_id AS i_class_id,
    item.i_category_id AS i_category_id,
    SUM(store_sales.ss_quantity * store_sales.ss_list_price) AS sales,
    COUNT(*) AS number_sales
  FROM store_sales AS store_sales
  CROSS JOIN _u_1 AS _u_1
  LEFT JOIN _u_0 AS _u_0
    ON `_u_0`.`ss_item_sk` = store_sales.ss_item_sk
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = store_sales.ss_sold_date_sk
    AND date_dim.d_moy = 11
    AND date_dim.d_year = 2001
  JOIN item AS item
    ON item.i_item_sk = store_sales.ss_item_sk
  WHERE
    NOT `_u_0`.`ss_item_sk` IS NULL
  GROUP BY
    item.i_brand_id,
    item.i_class_id,
    item.i_category_id
  HAVING
    MAX(_u_1.average_sales) < SUM(store_sales.ss_quantity * store_sales.ss_list_price)
  UNION ALL
  SELECT
    'catalog' AS channel,
    item.i_brand_id AS i_brand_id,
    item.i_class_id AS i_class_id,
    item.i_category_id AS i_category_id,
    SUM(catalog_sales.cs_quantity * catalog_sales.cs_list_price) AS sales,
    COUNT(*) AS number_sales
  FROM catalog_sales AS catalog_sales
  CROSS JOIN _u_1 AS _u_3
  LEFT JOIN _u_0 AS _u_2
    ON `_u_2`.`ss_item_sk` = catalog_sales.cs_item_sk
  JOIN date_dim AS date_dim
    ON catalog_sales.cs_sold_date_sk = date_dim.d_date_sk
    AND date_dim.d_moy = 11
    AND date_dim.d_year = 2001
  JOIN item AS item
    ON catalog_sales.cs_item_sk = item.i_item_sk
  WHERE
    NOT `_u_2`.`ss_item_sk` IS NULL
  GROUP BY
    item.i_brand_id,
    item.i_class_id,
    item.i_category_id
  HAVING
    MAX(_u_3.average_sales) < SUM(catalog_sales.cs_quantity * catalog_sales.cs_list_price)
  UNION ALL
  SELECT
    'web' AS channel,
    item.i_brand_id AS i_brand_id,
    item.i_class_id AS i_class_id,
    item.i_category_id AS i_category_id,
    SUM(web_sales.ws_quantity * web_sales.ws_list_price) AS sales,
    COUNT(*) AS number_sales
  FROM web_sales AS web_sales
  CROSS JOIN _u_1 AS _u_5
  LEFT JOIN _u_0 AS _u_4
    ON `_u_4`.`ss_item_sk` = web_sales.ws_item_sk
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = web_sales.ws_sold_date_sk
    AND date_dim.d_moy = 11
    AND date_dim.d_year = 2001
  JOIN item AS item
    ON item.i_item_sk = web_sales.ws_item_sk
  WHERE
    NOT `_u_4`.`ss_item_sk` IS NULL
  GROUP BY
    item.i_brand_id,
    item.i_class_id,
    item.i_category_id
  HAVING
    MAX(_u_5.average_sales) < SUM(web_sales.ws_quantity * web_sales.ws_list_price)
)
SELECT
  y.channel AS channel,
  y.i_brand_id AS i_brand_id,
  y.i_class_id AS i_class_id,
  y.i_category_id AS i_category_id,
  SUM(y.sales) AS _col_4,
  SUM(y.number_sales) AS _col_5
FROM y AS y
GROUP BY
ROLLUP (
  y.channel,
  y.i_brand_id,
  y.i_class_id,
  y.i_category_id
)
ORDER BY
  channel,
  i_brand_id,
  i_class_id,
  i_category_id
LIMIT 100