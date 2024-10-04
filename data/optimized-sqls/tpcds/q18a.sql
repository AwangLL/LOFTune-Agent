SELECT
  item.i_item_id AS i_item_id,
  customer_address.ca_country AS ca_country,
  customer_address.ca_state AS ca_state,
  customer_address.ca_county AS ca_county,
  AVG(CAST(catalog_sales.cs_quantity AS DECIMAL(12, 2))) AS agg1,
  AVG(CAST(catalog_sales.cs_list_price AS DECIMAL(12, 2))) AS agg2,
  AVG(CAST(catalog_sales.cs_coupon_amt AS DECIMAL(12, 2))) AS agg3,
  AVG(CAST(catalog_sales.cs_sales_price AS DECIMAL(12, 2))) AS agg4,
  AVG(CAST(catalog_sales.cs_net_profit AS DECIMAL(12, 2))) AS agg5,
  AVG(CAST(customer.c_birth_year AS DECIMAL(12, 2))) AS agg6,
  AVG(CAST(cd1.cd_dep_count AS DECIMAL(12, 2))) AS agg7
FROM catalog_sales AS catalog_sales
JOIN customer_demographics AS cd1
  ON catalog_sales.cs_bill_cdemo_sk = cd1.cd_demo_sk
  AND cd1.cd_education_status = 'Unknown'
  AND cd1.cd_gender = 'M'
JOIN customer AS customer
  ON catalog_sales.cs_bill_customer_sk = customer.c_customer_sk
  AND customer.c_birth_month IN (1, 2, 3, 4, 5, 6, 7, 8)
JOIN date_dim AS date_dim
  ON catalog_sales.cs_sold_date_sk = date_dim.d_date_sk AND date_dim.d_year > 1996
JOIN item AS item
  ON catalog_sales.cs_item_sk = item.i_item_sk
JOIN customer_demographics AS cd2
  ON cd2.cd_demo_sk = customer.c_current_cdemo_sk
JOIN customer_address AS customer_address
  ON NOT customer_address.ca_state IN ('IN', 'MS', 'ND', 'NM', 'OK')
  AND customer.c_current_addr_sk = customer_address.ca_address_sk
GROUP BY
ROLLUP (
  item.i_item_id,
  customer_address.ca_country,
  customer_address.ca_state,
  customer_address.ca_county
)
ORDER BY
  ca_country,
  ca_state,
  ca_county,
  i_item_id
LIMIT 100