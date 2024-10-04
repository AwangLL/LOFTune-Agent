WITH _u_0 AS (
  SELECT DISTINCT
    date_dim.d_month_seq AS d_month_seq
  FROM date_dim AS date_dim
  WHERE
    date_dim.d_moy = 4 AND date_dim.d_year = 2000
), _u_1 AS (
  SELECT
    AVG(j.i_current_price) AS _col_0,
    j.i_category AS _u_2
  FROM item AS j
  GROUP BY
    j.i_category
)
SELECT
  a.ca_state AS state,
  COUNT(*) AS cnt
FROM customer_address AS a
JOIN customer AS c
  ON a.ca_address_sk = c.c_current_addr_sk
JOIN store_sales AS s
  ON c.c_customer_sk = s.ss_customer_sk
JOIN date_dim AS d
  ON d.d_date_sk = s.ss_sold_date_sk
JOIN item AS i
  ON i.i_item_sk = s.ss_item_sk
JOIN _u_0 AS _u_0
  ON _u_0.d_month_seq = d.d_month_seq
LEFT JOIN _u_1 AS _u_1
  ON _u_1._u_2 = i.i_category
WHERE
  i.i_current_price > 1.3 * _u_1._col_0
GROUP BY
  a.ca_state
HAVING
  COUNT(*) >= 10
ORDER BY
  cnt
LIMIT 100