WITH wscs AS (
  SELECT
    web_sales.ws_sold_date_sk AS sold_date_sk,
    web_sales.ws_ext_sales_price AS sales_price
  FROM web_sales AS web_sales
  UNION ALL
  (
    SELECT
      catalog_sales.cs_sold_date_sk AS sold_date_sk,
      catalog_sales.cs_ext_sales_price AS sales_price
    FROM catalog_sales AS catalog_sales
  )
), wswscs AS (
  SELECT
    date_dim.d_week_seq AS d_week_seq,
    SUM(CASE WHEN date_dim.d_day_name = 'Sunday' THEN wscs.sales_price ELSE NULL END) AS sun_sales,
    SUM(CASE WHEN date_dim.d_day_name = 'Monday' THEN wscs.sales_price ELSE NULL END) AS mon_sales,
    SUM(CASE WHEN date_dim.d_day_name = 'Tuesday' THEN wscs.sales_price ELSE NULL END) AS tue_sales,
    SUM(CASE WHEN date_dim.d_day_name = 'Wednesday' THEN wscs.sales_price ELSE NULL END) AS wed_sales,
    SUM(CASE WHEN date_dim.d_day_name = 'Thursday' THEN wscs.sales_price ELSE NULL END) AS thu_sales,
    SUM(CASE WHEN date_dim.d_day_name = 'Friday' THEN wscs.sales_price ELSE NULL END) AS fri_sales,
    SUM(CASE WHEN date_dim.d_day_name = 'Saturday' THEN wscs.sales_price ELSE NULL END) AS sat_sales
  FROM wscs
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = wscs.sold_date_sk
  GROUP BY
    date_dim.d_week_seq
), y AS (
  SELECT
    wswscs.d_week_seq AS d_week_seq1,
    wswscs.sun_sales AS sun_sales1,
    wswscs.mon_sales AS mon_sales1,
    wswscs.tue_sales AS tue_sales1,
    wswscs.wed_sales AS wed_sales1,
    wswscs.thu_sales AS thu_sales1,
    wswscs.fri_sales AS fri_sales1,
    wswscs.sat_sales AS sat_sales1
  FROM wswscs
  JOIN date_dim AS date_dim
    ON date_dim.d_week_seq = wswscs.d_week_seq AND date_dim.d_year = 2001
), z AS (
  SELECT
    wswscs.d_week_seq AS d_week_seq2,
    wswscs.sun_sales AS sun_sales2,
    wswscs.mon_sales AS mon_sales2,
    wswscs.tue_sales AS tue_sales2,
    wswscs.wed_sales AS wed_sales2,
    wswscs.thu_sales AS thu_sales2,
    wswscs.fri_sales AS fri_sales2,
    wswscs.sat_sales AS sat_sales2
  FROM wswscs
  JOIN date_dim AS date_dim
    ON date_dim.d_week_seq = wswscs.d_week_seq AND date_dim.d_year = 2002
)
SELECT
  y.d_week_seq1 AS d_week_seq1,
  ROUND(y.sun_sales1 / z.sun_sales2, 2) AS _col_1,
  ROUND(y.mon_sales1 / z.mon_sales2, 2) AS _col_2,
  ROUND(y.tue_sales1 / z.tue_sales2, 2) AS _col_3,
  ROUND(y.wed_sales1 / z.wed_sales2, 2) AS _col_4,
  ROUND(y.thu_sales1 / z.thu_sales2, 2) AS _col_5,
  ROUND(y.fri_sales1 / z.fri_sales2, 2) AS _col_6,
  ROUND(y.sat_sales1 / z.sat_sales2, 2) AS _col_7
FROM y AS y
JOIN z AS z
  ON y.d_week_seq1 = z.d_week_seq2 - 53
ORDER BY
  d_week_seq1