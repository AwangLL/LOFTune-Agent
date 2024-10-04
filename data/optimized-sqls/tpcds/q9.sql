WITH _u_0 AS (
  SELECT
    COUNT(*) AS _col_0
  FROM store_sales AS store_sales
  WHERE
    store_sales.ss_quantity <= 20 AND store_sales.ss_quantity >= 1
), _u_1 AS (
  SELECT
    AVG(store_sales.ss_ext_discount_amt) AS _col_0
  FROM store_sales AS store_sales
  WHERE
    store_sales.ss_quantity <= 20 AND store_sales.ss_quantity >= 1
), _u_10 AS (
  SELECT
    AVG(store_sales.ss_ext_discount_amt) AS _col_0
  FROM store_sales AS store_sales
  WHERE
    store_sales.ss_quantity <= 80 AND store_sales.ss_quantity >= 61
), _u_11 AS (
  SELECT
    AVG(store_sales.ss_net_paid) AS _col_0
  FROM store_sales AS store_sales
  WHERE
    store_sales.ss_quantity <= 80 AND store_sales.ss_quantity >= 61
), _u_12 AS (
  SELECT
    COUNT(*) AS _col_0
  FROM store_sales AS store_sales
  WHERE
    store_sales.ss_quantity <= 100 AND store_sales.ss_quantity >= 81
), _u_13 AS (
  SELECT
    AVG(store_sales.ss_ext_discount_amt) AS _col_0
  FROM store_sales AS store_sales
  WHERE
    store_sales.ss_quantity <= 100 AND store_sales.ss_quantity >= 81
), _u_14 AS (
  SELECT
    AVG(store_sales.ss_net_paid) AS _col_0
  FROM store_sales AS store_sales
  WHERE
    store_sales.ss_quantity <= 100 AND store_sales.ss_quantity >= 81
), _u_2 AS (
  SELECT
    AVG(store_sales.ss_net_paid) AS _col_0
  FROM store_sales AS store_sales
  WHERE
    store_sales.ss_quantity <= 20 AND store_sales.ss_quantity >= 1
), _u_3 AS (
  SELECT
    COUNT(*) AS _col_0
  FROM store_sales AS store_sales
  WHERE
    store_sales.ss_quantity <= 40 AND store_sales.ss_quantity >= 21
), _u_4 AS (
  SELECT
    AVG(store_sales.ss_ext_discount_amt) AS _col_0
  FROM store_sales AS store_sales
  WHERE
    store_sales.ss_quantity <= 40 AND store_sales.ss_quantity >= 21
), _u_5 AS (
  SELECT
    AVG(store_sales.ss_net_paid) AS _col_0
  FROM store_sales AS store_sales
  WHERE
    store_sales.ss_quantity <= 40 AND store_sales.ss_quantity >= 21
), _u_6 AS (
  SELECT
    COUNT(*) AS _col_0
  FROM store_sales AS store_sales
  WHERE
    store_sales.ss_quantity <= 60 AND store_sales.ss_quantity >= 41
), _u_7 AS (
  SELECT
    AVG(store_sales.ss_ext_discount_amt) AS _col_0
  FROM store_sales AS store_sales
  WHERE
    store_sales.ss_quantity <= 60 AND store_sales.ss_quantity >= 41
), _u_8 AS (
  SELECT
    AVG(store_sales.ss_net_paid) AS _col_0
  FROM store_sales AS store_sales
  WHERE
    store_sales.ss_quantity <= 60 AND store_sales.ss_quantity >= 41
), _u_9 AS (
  SELECT
    COUNT(*) AS _col_0
  FROM store_sales AS store_sales
  WHERE
    store_sales.ss_quantity <= 80 AND store_sales.ss_quantity >= 61
)
SELECT
  CASE
    WHEN MAX(_u_0._col_0) > 62316685
    THEN MAX(_u_1._col_0)
    ELSE MAX(_u_2._col_0)
  END AS bucket1,
  CASE
    WHEN MAX(_u_3._col_0) > 19045798
    THEN MAX(_u_4._col_0)
    ELSE MAX(_u_5._col_0)
  END AS bucket2,
  CASE
    WHEN MAX(_u_6._col_0) > 365541424
    THEN MAX(_u_7._col_0)
    ELSE MAX(_u_8._col_0)
  END AS bucket3,
  CASE
    WHEN MAX(_u_9._col_0) > 216357808
    THEN MAX(_u_10._col_0)
    ELSE MAX(_u_11._col_0)
  END AS bucket4,
  CASE
    WHEN MAX(_u_12._col_0) > 184483884
    THEN MAX(_u_13._col_0)
    ELSE MAX(_u_14._col_0)
  END AS bucket5
FROM reason AS reason
CROSS JOIN _u_0 AS _u_0
CROSS JOIN _u_1 AS _u_1
CROSS JOIN _u_10 AS _u_10
CROSS JOIN _u_11 AS _u_11
CROSS JOIN _u_12 AS _u_12
CROSS JOIN _u_13 AS _u_13
CROSS JOIN _u_14 AS _u_14
CROSS JOIN _u_2 AS _u_2
CROSS JOIN _u_3 AS _u_3
CROSS JOIN _u_4 AS _u_4
CROSS JOIN _u_5 AS _u_5
CROSS JOIN _u_6 AS _u_6
CROSS JOIN _u_7 AS _u_7
CROSS JOIN _u_8 AS _u_8
CROSS JOIN _u_9 AS _u_9
WHERE
  reason.r_reason_sk = 1