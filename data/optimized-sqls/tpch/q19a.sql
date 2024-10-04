/* using default substitutions */
SELECT
  SUM(lineitem.l_extendedprice * (
    1 - lineitem.l_discount
  )) AS revenue
FROM lineitem AS lineitem
JOIN part AS part
  ON (
    lineitem.l_partkey = part.p_partkey
    AND lineitem.l_quantity <= 20
    AND lineitem.l_quantity >= 7
    AND lineitem.l_shipinstruct = 'DELIVER IN PERSON'
    AND lineitem.l_shipmode IN ('AIR', 'AIR REG')
    AND part.p_brand = 'Brand#23'
    AND part.p_container IN ('MED BAG', 'MED BOX', 'MED PACK', 'MED PKG')
    AND part.p_size <= 7
  )
  OR (
    lineitem.l_partkey = part.p_partkey
    AND lineitem.l_quantity <= 25
    AND lineitem.l_quantity >= 20
    AND lineitem.l_shipinstruct = 'DELIVER IN PERSON'
    AND lineitem.l_shipmode IN ('AIR', 'AIR REG')
    AND part.p_brand = 'Brand#21'
    AND part.p_container IN ('LG BOX', 'LG CASE', 'LG PACK', 'LG PKG')
    AND part.p_size <= 11
    AND part.p_size >= 3
  )
  OR (
    lineitem.l_partkey = part.p_partkey
    AND lineitem.l_quantity <= 9
    AND lineitem.l_quantity >= 2
    AND lineitem.l_shipinstruct = 'DELIVER IN PERSON'
    AND lineitem.l_shipmode IN ('AIR', 'AIR REG')
    AND part.p_brand = 'Brand#45'
    AND part.p_container IN ('SM BOX', 'SM CASE', 'SM PACK', 'SM PKG')
    AND part.p_size >= 3
  )
WHERE
  (
    lineitem.l_partkey = part.p_partkey
    AND lineitem.l_quantity <= 20
    AND lineitem.l_quantity >= 7
    AND lineitem.l_shipinstruct = 'DELIVER IN PERSON'
    AND lineitem.l_shipmode IN ('AIR', 'AIR REG')
    AND part.p_brand = 'Brand#23'
    AND part.p_container IN ('MED BAG', 'MED BOX', 'MED PACK', 'MED PKG')
    AND part.p_size <= 7
  )
  OR (
    lineitem.l_partkey = part.p_partkey
    AND lineitem.l_quantity <= 25
    AND lineitem.l_quantity >= 20
    AND lineitem.l_shipinstruct = 'DELIVER IN PERSON'
    AND lineitem.l_shipmode IN ('AIR', 'AIR REG')
    AND part.p_brand = 'Brand#21'
    AND part.p_container IN ('LG BOX', 'LG CASE', 'LG PACK', 'LG PKG')
    AND part.p_size <= 11
    AND part.p_size >= 3
  )
  OR (
    lineitem.l_partkey = part.p_partkey
    AND lineitem.l_quantity <= 9
    AND lineitem.l_quantity >= 2
    AND lineitem.l_shipinstruct = 'DELIVER IN PERSON'
    AND lineitem.l_shipmode IN ('AIR', 'AIR REG')
    AND part.p_brand = 'Brand#45'
    AND part.p_container IN ('SM BOX', 'SM CASE', 'SM PACK', 'SM PKG')
    AND part.p_size >= 3
  )