WITH v1 AS (
  SELECT
    item.i_category AS i_category,
    item.i_brand AS i_brand,
    call_center.cc_name AS cc_name,
    date_dim.d_year AS d_year,
    date_dim.d_moy AS d_moy,
    SUM(catalog_sales.cs_sales_price) AS sum_sales,
    AVG(SUM(catalog_sales.cs_sales_price)) OVER (PARTITION BY item.i_category, item.i_brand, call_center.cc_name, date_dim.d_year) AS avg_monthly_sales,
    RANK() OVER (PARTITION BY item.i_category, item.i_brand, call_center.cc_name ORDER BY date_dim.d_year, date_dim.d_moy) AS rn
  FROM item AS item
  JOIN catalog_sales AS catalog_sales
    ON catalog_sales.cs_item_sk = item.i_item_sk
  JOIN call_center AS call_center
    ON call_center.cc_call_center_sk = catalog_sales.cs_call_center_sk
  JOIN date_dim AS date_dim
    ON catalog_sales.cs_sold_date_sk = date_dim.d_date_sk
    AND (
      date_dim.d_moy = 1 OR date_dim.d_moy = 12 OR date_dim.d_year = 1999
    )
    AND (
      date_dim.d_moy = 1 OR date_dim.d_year = 1998 OR date_dim.d_year = 1999
    )
    AND (
      date_dim.d_moy = 12 OR date_dim.d_year = 1999 OR date_dim.d_year = 2000
    )
    AND (
      date_dim.d_year = 1998 OR date_dim.d_year = 1999 OR date_dim.d_year = 2000
    )
  GROUP BY
    item.i_category,
    item.i_brand,
    call_center.cc_name,
    date_dim.d_year,
    date_dim.d_moy
)
SELECT
  v1.i_category AS i_category,
  v1.i_brand AS i_brand,
  v1.cc_name AS cc_name,
  v1.d_year AS d_year,
  v1.d_moy AS d_moy,
  v1.avg_monthly_sales AS avg_monthly_sales,
  v1.sum_sales AS sum_sales,
  v1_lag.sum_sales AS psum,
  v1_lead.sum_sales AS nsum
FROM v1
JOIN v1 AS v1_lag
  ON v1.cc_name = v1_lag.cc_name
  AND v1.i_brand = v1_lag.i_brand
  AND v1.i_category = v1_lag.i_category
  AND v1.rn = v1_lag.rn + 1
JOIN v1 AS v1_lead
  ON v1.cc_name = v1_lead.cc_name
  AND v1.i_brand = v1_lead.i_brand
  AND v1.i_category = v1_lead.i_category
  AND v1.rn = v1_lead.rn - 1
WHERE
  CASE
    WHEN v1.avg_monthly_sales > 0
    THEN ABS(v1.sum_sales - v1.avg_monthly_sales) / v1.avg_monthly_sales
    ELSE NULL
  END > 0.1
  AND v1.avg_monthly_sales > 0
  AND v1.d_year = 1999
ORDER BY
  v1.sum_sales - v1.avg_monthly_sales,
  cc_name
LIMIT 100