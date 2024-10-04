WITH b1 AS (
  SELECT
    AVG(store_sales.ss_list_price) AS b1_lp,
    COUNT(store_sales.ss_list_price) AS b1_cnt,
    COUNT(DISTINCT store_sales.ss_list_price) AS b1_cntd
  FROM store_sales AS store_sales
  WHERE
    (
      store_sales.ss_coupon_amt <= 1459 AND store_sales.ss_coupon_amt >= 459
      OR store_sales.ss_list_price <= 18 AND store_sales.ss_list_price >= 8
      OR store_sales.ss_wholesale_cost <= 77 AND store_sales.ss_wholesale_cost >= 57
    )
    AND store_sales.ss_quantity <= 5
    AND store_sales.ss_quantity >= 0
), b2 AS (
  SELECT
    AVG(store_sales.ss_list_price) AS b2_lp,
    COUNT(store_sales.ss_list_price) AS b2_cnt,
    COUNT(DISTINCT store_sales.ss_list_price) AS b2_cntd
  FROM store_sales AS store_sales
  WHERE
    (
      store_sales.ss_coupon_amt <= 3323 AND store_sales.ss_coupon_amt >= 2323
      OR store_sales.ss_list_price <= 100 AND store_sales.ss_list_price >= 90
      OR store_sales.ss_wholesale_cost <= 51 AND store_sales.ss_wholesale_cost >= 31
    )
    AND store_sales.ss_quantity <= 10
    AND store_sales.ss_quantity >= 6
), b3 AS (
  SELECT
    AVG(store_sales.ss_list_price) AS b3_lp,
    COUNT(store_sales.ss_list_price) AS b3_cnt,
    COUNT(DISTINCT store_sales.ss_list_price) AS b3_cntd
  FROM store_sales AS store_sales
  WHERE
    (
      store_sales.ss_coupon_amt <= 13214 AND store_sales.ss_coupon_amt >= 12214
      OR store_sales.ss_list_price <= 152 AND store_sales.ss_list_price >= 142
      OR store_sales.ss_wholesale_cost <= 99 AND store_sales.ss_wholesale_cost >= 79
    )
    AND store_sales.ss_quantity <= 15
    AND store_sales.ss_quantity >= 11
), b4 AS (
  SELECT
    AVG(store_sales.ss_list_price) AS b4_lp,
    COUNT(store_sales.ss_list_price) AS b4_cnt,
    COUNT(DISTINCT store_sales.ss_list_price) AS b4_cntd
  FROM store_sales AS store_sales
  WHERE
    (
      store_sales.ss_coupon_amt <= 7071 AND store_sales.ss_coupon_amt >= 6071
      OR store_sales.ss_list_price <= 145 AND store_sales.ss_list_price >= 135
      OR store_sales.ss_wholesale_cost <= 58 AND store_sales.ss_wholesale_cost >= 38
    )
    AND store_sales.ss_quantity <= 20
    AND store_sales.ss_quantity >= 16
), b5 AS (
  SELECT
    AVG(store_sales.ss_list_price) AS b5_lp,
    COUNT(store_sales.ss_list_price) AS b5_cnt,
    COUNT(DISTINCT store_sales.ss_list_price) AS b5_cntd
  FROM store_sales AS store_sales
  WHERE
    (
      store_sales.ss_coupon_amt <= 1836 AND store_sales.ss_coupon_amt >= 836
      OR store_sales.ss_list_price <= 132 AND store_sales.ss_list_price >= 122
      OR store_sales.ss_wholesale_cost <= 37 AND store_sales.ss_wholesale_cost >= 17
    )
    AND store_sales.ss_quantity <= 25
    AND store_sales.ss_quantity >= 21
), b6 AS (
  SELECT
    AVG(store_sales.ss_list_price) AS b6_lp,
    COUNT(store_sales.ss_list_price) AS b6_cnt,
    COUNT(DISTINCT store_sales.ss_list_price) AS b6_cntd
  FROM store_sales AS store_sales
  WHERE
    (
      store_sales.ss_coupon_amt <= 8326 AND store_sales.ss_coupon_amt >= 7326
      OR store_sales.ss_list_price <= 164 AND store_sales.ss_list_price >= 154
      OR store_sales.ss_wholesale_cost <= 27 AND store_sales.ss_wholesale_cost >= 7
    )
    AND store_sales.ss_quantity <= 30
    AND store_sales.ss_quantity >= 26
)
SELECT
  b1.b1_lp AS b1_lp,
  b1.b1_cnt AS b1_cnt,
  b1.b1_cntd AS b1_cntd,
  b2.b2_lp AS b2_lp,
  b2.b2_cnt AS b2_cnt,
  b2.b2_cntd AS b2_cntd,
  b3.b3_lp AS b3_lp,
  b3.b3_cnt AS b3_cnt,
  b3.b3_cntd AS b3_cntd,
  b4.b4_lp AS b4_lp,
  b4.b4_cnt AS b4_cnt,
  b4.b4_cntd AS b4_cntd,
  b5.b5_lp AS b5_lp,
  b5.b5_cnt AS b5_cnt,
  b5.b5_cntd AS b5_cntd,
  b6.b6_lp AS b6_lp,
  b6.b6_cnt AS b6_cnt,
  b6.b6_cntd AS b6_cntd
FROM b1 AS b1
CROSS JOIN b2 AS b2
CROSS JOIN b3 AS b3
CROSS JOIN b4 AS b4
CROSS JOIN b5 AS b5
CROSS JOIN b6 AS b6
LIMIT 100