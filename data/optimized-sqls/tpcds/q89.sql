WITH tmp1 AS (
  SELECT
    item.i_category AS i_category,
    item.i_class AS i_class,
    item.i_brand AS i_brand,
    store.s_store_name AS s_store_name,
    store.s_company_name AS s_company_name,
    date_dim.d_moy AS d_moy,
    SUM(store_sales.ss_sales_price) AS sum_sales,
    AVG(SUM(store_sales.ss_sales_price)) OVER (PARTITION BY item.i_category, item.i_brand, store.s_store_name, store.s_company_name) AS avg_monthly_sales
  FROM item AS item
  JOIN store_sales AS store_sales
    ON item.i_item_sk = store_sales.ss_item_sk
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = store_sales.ss_sold_date_sk AND date_dim.d_year IN (1999)
  JOIN store AS store
    ON store.s_store_sk = store_sales.ss_store_sk
  WHERE
    (
      item.i_category IN ('Books', 'Electronics', 'Sports')
      OR item.i_category IN ('Jewelry', 'Men', 'Women')
    )
    AND (
      item.i_category IN ('Books', 'Electronics', 'Sports')
      OR item.i_class IN ('birdal', 'dresses', 'shirts')
    )
    AND (
      item.i_category IN ('Jewelry', 'Men', 'Women')
      OR item.i_class IN ('computers', 'football', 'stereo')
    )
    AND (
      item.i_class IN ('computers', 'football', 'stereo')
      OR item.i_class IN ('birdal', 'dresses', 'shirts')
    )
  GROUP BY
    item.i_category,
    item.i_class,
    item.i_brand,
    store.s_store_name,
    store.s_company_name,
    date_dim.d_moy
)
SELECT
  tmp1.i_category AS i_category,
  tmp1.i_class AS i_class,
  tmp1.i_brand AS i_brand,
  tmp1.s_store_name AS s_store_name,
  tmp1.s_company_name AS s_company_name,
  tmp1.d_moy AS d_moy,
  tmp1.sum_sales AS sum_sales,
  tmp1.avg_monthly_sales AS avg_monthly_sales
FROM tmp1 AS tmp1
WHERE
  CASE
    WHEN tmp1.avg_monthly_sales <> 0
    THEN (
      ABS(tmp1.sum_sales - tmp1.avg_monthly_sales) / tmp1.avg_monthly_sales
    )
    ELSE NULL
  END > 0.1
ORDER BY
  tmp1.sum_sales - tmp1.avg_monthly_sales,
  tmp1.s_store_name
LIMIT 100