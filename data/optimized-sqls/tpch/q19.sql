/* using default substitutions */
SELECT
  SUM(lineitem.l_extendedprice * (
    1 - lineitem.l_discount
  )) AS revenue
FROM lineitem AS lineitem
JOIN part AS part
  ON (
    lineitem.l_partkey = part.p_partkey
    AND lineitem.l_quantity <= 11
    AND lineitem.l_quantity >= 1
    AND lineitem.l_shipinstruct = 'DELIVER IN PERSON'
    AND lineitem.l_shipmode IN ('AIR', 'AIR REG')
    AND part.p_brand = 'Brand#12'
    AND part.p_container IN ('SM BOX', 'SM CASE', 'SM PACK', 'SM PKG')
    AND part.p_size <= 5
    AND part.p_size >= 1
  )
  OR (
    lineitem.l_partkey = part.p_partkey
    AND lineitem.l_quantity <= 20
    AND lineitem.l_quantity >= 10
    AND lineitem.l_shipinstruct = 'DELIVER IN PERSON'
    AND lineitem.l_shipmode IN ('AIR', 'AIR REG')
    AND part.p_brand = 'Brand#23'
    AND part.p_container IN ('MED BAG', 'MED BOX', 'MED PACK', 'MED PKG')
    AND part.p_size <= 10
    AND part.p_size >= 1
  )
  OR (
    lineitem.l_partkey = part.p_partkey
    AND lineitem.l_quantity <= 30
    AND lineitem.l_quantity >= 20
    AND lineitem.l_shipinstruct = 'DELIVER IN PERSON'
    AND lineitem.l_shipmode IN ('AIR', 'AIR REG')
    AND part.p_brand = 'Brand#34'
    AND part.p_container IN ('LG BOX', 'LG CASE', 'LG PACK', 'LG PKG')
    AND part.p_size <= 15
    AND part.p_size >= 1
  )
WHERE
  (
    lineitem.l_partkey = part.p_partkey
    AND lineitem.l_quantity <= 11
    AND lineitem.l_quantity >= 1
    AND lineitem.l_shipinstruct = 'DELIVER IN PERSON'
    AND lineitem.l_shipmode IN ('AIR', 'AIR REG')
    AND part.p_brand = 'Brand#12'
    AND part.p_container IN ('SM BOX', 'SM CASE', 'SM PACK', 'SM PKG')
    AND part.p_size <= 5
    AND part.p_size >= 1
  )
  OR (
    lineitem.l_partkey = part.p_partkey
    AND lineitem.l_quantity <= 20
    AND lineitem.l_quantity >= 10
    AND lineitem.l_shipinstruct = 'DELIVER IN PERSON'
    AND lineitem.l_shipmode IN ('AIR', 'AIR REG')
    AND part.p_brand = 'Brand#23'
    AND part.p_container IN ('MED BAG', 'MED BOX', 'MED PACK', 'MED PKG')
    AND part.p_size <= 10
    AND part.p_size >= 1
  )
  OR (
    lineitem.l_partkey = part.p_partkey
    AND lineitem.l_quantity <= 30
    AND lineitem.l_quantity >= 20
    AND lineitem.l_shipinstruct = 'DELIVER IN PERSON'
    AND lineitem.l_shipmode IN ('AIR', 'AIR REG')
    AND part.p_brand = 'Brand#34'
    AND part.p_container IN ('LG BOX', 'LG CASE', 'LG PACK', 'LG PKG')
    AND part.p_size <= 15
    AND part.p_size >= 1
  )