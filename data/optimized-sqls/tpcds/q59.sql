WITH wss AS (
  SELECT
    date_dim.d_week_seq AS d_week_seq,
    store_sales.ss_store_sk AS ss_store_sk,
    SUM(
      CASE
        WHEN date_dim.d_day_name = 'Sunday'
        THEN store_sales.ss_sales_price
        ELSE NULL
      END
    ) AS sun_sales,
    SUM(
      CASE
        WHEN date_dim.d_day_name = 'Monday'
        THEN store_sales.ss_sales_price
        ELSE NULL
      END
    ) AS mon_sales,
    SUM(
      CASE
        WHEN date_dim.d_day_name = 'Tuesday'
        THEN store_sales.ss_sales_price
        ELSE NULL
      END
    ) AS tue_sales,
    SUM(
      CASE
        WHEN date_dim.d_day_name = 'Wednesday'
        THEN store_sales.ss_sales_price
        ELSE NULL
      END
    ) AS wed_sales,
    SUM(
      CASE
        WHEN date_dim.d_day_name = 'Thursday'
        THEN store_sales.ss_sales_price
        ELSE NULL
      END
    ) AS thu_sales,
    SUM(
      CASE
        WHEN date_dim.d_day_name = 'Friday'
        THEN store_sales.ss_sales_price
        ELSE NULL
      END
    ) AS fri_sales,
    SUM(
      CASE
        WHEN date_dim.d_day_name = 'Saturday'
        THEN store_sales.ss_sales_price
        ELSE NULL
      END
    ) AS sat_sales
  FROM store_sales AS store_sales
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = store_sales.ss_sold_date_sk
  GROUP BY
    date_dim.d_week_seq,
    store_sales.ss_store_sk
), y AS (
  SELECT
    store.s_store_name AS s_store_name1,
    wss.d_week_seq AS d_week_seq1,
    store.s_store_id AS s_store_id1,
    wss.sun_sales AS sun_sales1,
    wss.mon_sales AS mon_sales1,
    wss.tue_sales AS tue_sales1,
    wss.wed_sales AS wed_sales1,
    wss.thu_sales AS thu_sales1,
    wss.fri_sales AS fri_sales1,
    wss.sat_sales AS sat_sales1
  FROM wss
  JOIN date_dim AS d
    ON d.d_month_seq <= 1223 AND d.d_month_seq >= 1212 AND d.d_week_seq = wss.d_week_seq
  JOIN store AS store
    ON store.s_store_sk = wss.ss_store_sk
), x AS (
  SELECT
    wss.d_week_seq AS d_week_seq2,
    store.s_store_id AS s_store_id2,
    wss.sun_sales AS sun_sales2,
    wss.mon_sales AS mon_sales2,
    wss.tue_sales AS tue_sales2,
    wss.wed_sales AS wed_sales2,
    wss.thu_sales AS thu_sales2,
    wss.fri_sales AS fri_sales2,
    wss.sat_sales AS sat_sales2
  FROM wss
  JOIN date_dim AS d
    ON d.d_month_seq <= 1235 AND d.d_month_seq >= 1224 AND d.d_week_seq = wss.d_week_seq
  JOIN store AS store
    ON store.s_store_sk = wss.ss_store_sk
)
SELECT
  y.s_store_name1 AS s_store_name1,
  y.s_store_id1 AS s_store_id1,
  y.d_week_seq1 AS d_week_seq1,
  y.sun_sales1 / x.sun_sales2 AS _col_3,
  y.mon_sales1 / x.mon_sales2 AS _col_4,
  y.tue_sales1 / x.tue_sales2 AS _col_5,
  y.wed_sales1 / x.wed_sales2 AS _col_6,
  y.thu_sales1 / x.thu_sales2 AS _col_7,
  y.fri_sales1 / x.fri_sales2 AS _col_8,
  y.sat_sales1 / x.sat_sales2 AS _col_9
FROM y AS y
JOIN x AS x
  ON x.s_store_id2 = y.s_store_id1 AND y.d_week_seq1 = x.d_week_seq2 - 52
ORDER BY
  s_store_name1,
  s_store_id1,
  d_week_seq1
LIMIT 100