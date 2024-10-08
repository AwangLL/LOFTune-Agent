WITH s1 AS (
  SELECT
    COUNT(*) AS h8_30_to_9
  FROM store_sales AS store_sales
  JOIN household_demographics AS household_demographics
    ON household_demographics.hd_demo_sk = store_sales.ss_hdemo_sk
    AND (
      household_demographics.hd_dep_count = 0
      OR household_demographics.hd_dep_count = 2
      OR household_demographics.hd_dep_count = 4
    )
    AND (
      household_demographics.hd_dep_count = 2
      OR household_demographics.hd_dep_count = 4
      OR household_demographics.hd_vehicle_count <= 2
    )
    AND (
      household_demographics.hd_dep_count = 4
      OR household_demographics.hd_vehicle_count <= 4
    )
    AND household_demographics.hd_vehicle_count <= 6
  JOIN store AS store
    ON store.s_store_name = 'ese' AND store.s_store_sk = store_sales.ss_store_sk
  JOIN time_dim AS time_dim
    ON store_sales.ss_sold_time_sk = time_dim.t_time_sk
    AND time_dim.t_hour = 8
    AND time_dim.t_minute >= 30
), s2 AS (
  SELECT
    COUNT(*) AS h9_to_9_30
  FROM store_sales AS store_sales
  JOIN household_demographics AS household_demographics
    ON household_demographics.hd_demo_sk = store_sales.ss_hdemo_sk
    AND (
      household_demographics.hd_dep_count = 0
      OR household_demographics.hd_dep_count = 2
      OR household_demographics.hd_dep_count = 4
    )
    AND (
      household_demographics.hd_dep_count = 2
      OR household_demographics.hd_dep_count = 4
      OR household_demographics.hd_vehicle_count <= 2
    )
    AND (
      household_demographics.hd_dep_count = 4
      OR household_demographics.hd_vehicle_count <= 4
    )
    AND household_demographics.hd_vehicle_count <= 6
  JOIN store AS store
    ON store.s_store_name = 'ese' AND store.s_store_sk = store_sales.ss_store_sk
  JOIN time_dim AS time_dim
    ON store_sales.ss_sold_time_sk = time_dim.t_time_sk
    AND time_dim.t_hour = 9
    AND time_dim.t_minute < 30
), s3 AS (
  SELECT
    COUNT(*) AS h9_30_to_10
  FROM store_sales AS store_sales
  JOIN household_demographics AS household_demographics
    ON household_demographics.hd_demo_sk = store_sales.ss_hdemo_sk
    AND (
      household_demographics.hd_dep_count = 0
      OR household_demographics.hd_dep_count = 2
      OR household_demographics.hd_dep_count = 4
    )
    AND (
      household_demographics.hd_dep_count = 2
      OR household_demographics.hd_dep_count = 4
      OR household_demographics.hd_vehicle_count <= 2
    )
    AND (
      household_demographics.hd_dep_count = 4
      OR household_demographics.hd_vehicle_count <= 4
    )
    AND household_demographics.hd_vehicle_count <= 6
  JOIN store AS store
    ON store.s_store_name = 'ese' AND store.s_store_sk = store_sales.ss_store_sk
  JOIN time_dim AS time_dim
    ON store_sales.ss_sold_time_sk = time_dim.t_time_sk
    AND time_dim.t_hour = 9
    AND time_dim.t_minute >= 30
), s4 AS (
  SELECT
    COUNT(*) AS h10_to_10_30
  FROM store_sales AS store_sales
  JOIN household_demographics AS household_demographics
    ON household_demographics.hd_demo_sk = store_sales.ss_hdemo_sk
    AND (
      household_demographics.hd_dep_count = 0
      OR household_demographics.hd_dep_count = 2
      OR household_demographics.hd_dep_count = 4
    )
    AND (
      household_demographics.hd_dep_count = 2
      OR household_demographics.hd_dep_count = 4
      OR household_demographics.hd_vehicle_count <= 2
    )
    AND (
      household_demographics.hd_dep_count = 4
      OR household_demographics.hd_vehicle_count <= 4
    )
    AND household_demographics.hd_vehicle_count <= 6
  JOIN store AS store
    ON store.s_store_name = 'ese' AND store.s_store_sk = store_sales.ss_store_sk
  JOIN time_dim AS time_dim
    ON store_sales.ss_sold_time_sk = time_dim.t_time_sk
    AND time_dim.t_hour = 10
    AND time_dim.t_minute < 30
), s5 AS (
  SELECT
    COUNT(*) AS h10_30_to_11
  FROM store_sales AS store_sales
  JOIN household_demographics AS household_demographics
    ON household_demographics.hd_demo_sk = store_sales.ss_hdemo_sk
    AND (
      household_demographics.hd_dep_count = 0
      OR household_demographics.hd_dep_count = 2
      OR household_demographics.hd_dep_count = 4
    )
    AND (
      household_demographics.hd_dep_count = 2
      OR household_demographics.hd_dep_count = 4
      OR household_demographics.hd_vehicle_count <= 2
    )
    AND (
      household_demographics.hd_dep_count = 4
      OR household_demographics.hd_vehicle_count <= 4
    )
    AND household_demographics.hd_vehicle_count <= 6
  JOIN store AS store
    ON store.s_store_name = 'ese' AND store.s_store_sk = store_sales.ss_store_sk
  JOIN time_dim AS time_dim
    ON store_sales.ss_sold_time_sk = time_dim.t_time_sk
    AND time_dim.t_hour = 10
    AND time_dim.t_minute >= 30
), s6 AS (
  SELECT
    COUNT(*) AS h11_to_11_30
  FROM store_sales AS store_sales
  JOIN household_demographics AS household_demographics
    ON household_demographics.hd_demo_sk = store_sales.ss_hdemo_sk
    AND (
      household_demographics.hd_dep_count = 0
      OR household_demographics.hd_dep_count = 2
      OR household_demographics.hd_dep_count = 4
    )
    AND (
      household_demographics.hd_dep_count = 2
      OR household_demographics.hd_dep_count = 4
      OR household_demographics.hd_vehicle_count <= 2
    )
    AND (
      household_demographics.hd_dep_count = 4
      OR household_demographics.hd_vehicle_count <= 4
    )
    AND household_demographics.hd_vehicle_count <= 6
  JOIN store AS store
    ON store.s_store_name = 'ese' AND store.s_store_sk = store_sales.ss_store_sk
  JOIN time_dim AS time_dim
    ON store_sales.ss_sold_time_sk = time_dim.t_time_sk
    AND time_dim.t_hour = 11
    AND time_dim.t_minute < 30
), s7 AS (
  SELECT
    COUNT(*) AS h11_30_to_12
  FROM store_sales AS store_sales
  JOIN household_demographics AS household_demographics
    ON household_demographics.hd_demo_sk = store_sales.ss_hdemo_sk
    AND (
      household_demographics.hd_dep_count = 0
      OR household_demographics.hd_dep_count = 2
      OR household_demographics.hd_dep_count = 4
    )
    AND (
      household_demographics.hd_dep_count = 2
      OR household_demographics.hd_dep_count = 4
      OR household_demographics.hd_vehicle_count <= 2
    )
    AND (
      household_demographics.hd_dep_count = 4
      OR household_demographics.hd_vehicle_count <= 4
    )
    AND household_demographics.hd_vehicle_count <= 6
  JOIN store AS store
    ON store.s_store_name = 'ese' AND store.s_store_sk = store_sales.ss_store_sk
  JOIN time_dim AS time_dim
    ON store_sales.ss_sold_time_sk = time_dim.t_time_sk
    AND time_dim.t_hour = 11
    AND time_dim.t_minute >= 30
), s8 AS (
  SELECT
    COUNT(*) AS h12_to_12_30
  FROM store_sales AS store_sales
  JOIN household_demographics AS household_demographics
    ON household_demographics.hd_demo_sk = store_sales.ss_hdemo_sk
    AND (
      household_demographics.hd_dep_count = 0
      OR household_demographics.hd_dep_count = 2
      OR household_demographics.hd_dep_count = 4
    )
    AND (
      household_demographics.hd_dep_count = 2
      OR household_demographics.hd_dep_count = 4
      OR household_demographics.hd_vehicle_count <= 2
    )
    AND (
      household_demographics.hd_dep_count = 4
      OR household_demographics.hd_vehicle_count <= 4
    )
    AND household_demographics.hd_vehicle_count <= 6
  JOIN store AS store
    ON store.s_store_name = 'ese' AND store.s_store_sk = store_sales.ss_store_sk
  JOIN time_dim AS time_dim
    ON store_sales.ss_sold_time_sk = time_dim.t_time_sk
    AND time_dim.t_hour = 12
    AND time_dim.t_minute < 30
)
SELECT
  s1.h8_30_to_9 AS h8_30_to_9,
  s2.h9_to_9_30 AS h9_to_9_30,
  s3.h9_30_to_10 AS h9_30_to_10,
  s4.h10_to_10_30 AS h10_to_10_30,
  s5.h10_30_to_11 AS h10_30_to_11,
  s6.h11_to_11_30 AS h11_to_11_30,
  s7.h11_30_to_12 AS h11_30_to_12,
  s8.h12_to_12_30 AS h12_to_12_30
FROM s1 AS s1
CROSS JOIN s2 AS s2
CROSS JOIN s3 AS s3
CROSS JOIN s4 AS s4
CROSS JOIN s5 AS s5
CROSS JOIN s6 AS s6
CROSS JOIN s7 AS s7
CROSS JOIN s8 AS s8