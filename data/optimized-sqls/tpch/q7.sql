/* using default substitutions */
SELECT
  n1.n_name AS supp_nation,
  n2.n_name AS cust_nation,
  YEAR(TO_DATE(lineitem.l_shipdate)) AS l_year,
  SUM(lineitem.l_extendedprice * (
    1 - lineitem.l_discount
  )) AS revenue
FROM supplier AS supplier
JOIN lineitem AS lineitem
  ON lineitem.l_shipdate <= CAST('1996-12-31' AS DATE)
  AND lineitem.l_shipdate >= CAST('1995-01-01' AS DATE)
  AND lineitem.l_suppkey = supplier.s_suppkey
JOIN nation AS n1
  ON (
    n1.n_name = 'FRANCE' OR n1.n_name = 'GERMANY'
  )
  AND n1.n_nationkey = supplier.s_nationkey
JOIN nation AS n2
  ON (
    n1.n_name = 'FRANCE' OR n2.n_name = 'FRANCE'
  )
  AND (
    n1.n_name = 'GERMANY' OR n2.n_name = 'GERMANY'
  )
  AND (
    n2.n_name = 'FRANCE' OR n2.n_name = 'GERMANY'
  )
JOIN customer AS customer
  ON customer.c_nationkey = n2.n_nationkey
JOIN orders AS orders
  ON customer.c_custkey = orders.o_custkey AND lineitem.l_orderkey = orders.o_orderkey
GROUP BY
  n1.n_name,
  n2.n_name,
  YEAR(TO_DATE(lineitem.l_shipdate))
ORDER BY
  supp_nation,
  cust_nation,
  l_year