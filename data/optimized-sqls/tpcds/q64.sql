WITH cs_ui AS (
  SELECT
    catalog_sales.cs_item_sk AS cs_item_sk
  FROM catalog_sales AS catalog_sales
  JOIN catalog_returns AS catalog_returns
    ON catalog_returns.cr_item_sk = catalog_sales.cs_item_sk
    AND catalog_returns.cr_order_number = catalog_sales.cs_order_number
  GROUP BY
    catalog_sales.cs_item_sk
  HAVING
    2 * SUM(
      catalog_returns.cr_refunded_cash + catalog_returns.cr_reversed_charge + catalog_returns.cr_store_credit
    ) < SUM(catalog_sales.cs_ext_list_price)
), cross_sales AS (
  SELECT
    item.i_product_name AS product_name,
    item.i_item_sk AS item_sk,
    store.s_store_name AS store_name,
    store.s_zip AS store_zip,
    ad1.ca_street_number AS b_street_number,
    ad1.ca_street_name AS b_streen_name,
    ad1.ca_city AS b_city,
    ad1.ca_zip AS b_zip,
    ad2.ca_street_number AS c_street_number,
    ad2.ca_street_name AS c_street_name,
    ad2.ca_city AS c_city,
    ad2.ca_zip AS c_zip,
    d1.d_year AS syear,
    COUNT(*) AS cnt,
    SUM(store_sales.ss_wholesale_cost) AS s1,
    SUM(store_sales.ss_list_price) AS s2,
    SUM(store_sales.ss_coupon_amt) AS s3
  FROM store_sales AS store_sales
  CROSS JOIN income_band AS ib2
  JOIN customer_address AS ad1
    ON ad1.ca_address_sk = store_sales.ss_addr_sk
  JOIN cs_ui
    ON cs_ui.cs_item_sk = store_sales.ss_item_sk
  JOIN date_dim AS d1
    ON d1.d_date_sk = store_sales.ss_sold_date_sk
  JOIN household_demographics AS hd1
    ON hd1.hd_demo_sk = store_sales.ss_hdemo_sk
  JOIN household_demographics AS hd2
    ON hd2.hd_income_band_sk = ib2.ib_income_band_sk
  JOIN item AS item
    ON item.i_color IN ('burlywood', 'floral', 'indian', 'medium', 'purple', 'spring')
    AND item.i_current_price <= 74
    AND item.i_current_price >= 65
    AND item.i_item_sk = store_sales.ss_item_sk
  JOIN promotion AS promotion
    ON promotion.p_promo_sk = store_sales.ss_promo_sk
  JOIN store AS store
    ON store.s_store_sk = store_sales.ss_store_sk
  JOIN store_returns AS store_returns
    ON store_returns.sr_item_sk = store_sales.ss_item_sk
    AND store_returns.sr_ticket_number = store_sales.ss_ticket_number
  JOIN customer AS customer
    ON customer.c_current_hdemo_sk = hd2.hd_demo_sk
    AND customer.c_customer_sk = store_sales.ss_customer_sk
  JOIN income_band AS ib1
    ON hd1.hd_income_band_sk = ib1.ib_income_band_sk
  JOIN customer_address AS ad2
    ON ad2.ca_address_sk = customer.c_current_addr_sk
  JOIN customer_demographics AS cd2
    ON cd2.cd_demo_sk = customer.c_current_cdemo_sk
  JOIN date_dim AS d2
    ON customer.c_first_sales_date_sk = d2.d_date_sk
  JOIN date_dim AS d3
    ON customer.c_first_shipto_date_sk = d3.d_date_sk
  JOIN customer_demographics AS cd1
    ON cd1.cd_demo_sk = store_sales.ss_cdemo_sk
    AND cd1.cd_marital_status <> cd2.cd_marital_status
  GROUP BY
    item.i_product_name,
    item.i_item_sk,
    store.s_store_name,
    store.s_zip,
    ad1.ca_street_number,
    ad1.ca_street_name,
    ad1.ca_city,
    ad1.ca_zip,
    ad2.ca_street_number,
    ad2.ca_street_name,
    ad2.ca_city,
    ad2.ca_zip,
    d1.d_year,
    d2.d_year,
    d3.d_year
)
SELECT
  cs1.product_name AS product_name,
  cs1.store_name AS store_name,
  cs1.store_zip AS store_zip,
  cs1.b_street_number AS b_street_number,
  cs1.b_streen_name AS b_streen_name,
  cs1.b_city AS b_city,
  cs1.b_zip AS b_zip,
  cs1.c_street_number AS c_street_number,
  cs1.c_street_name AS c_street_name,
  cs1.c_city AS c_city,
  cs1.c_zip AS c_zip,
  cs1.syear AS syear,
  cs1.cnt AS cnt,
  cs1.s1 AS s1,
  cs1.s2 AS s2,
  cs1.s3 AS s3,
  cs2.s1 AS s1,
  cs2.s2 AS s2,
  cs2.s3 AS s3,
  cs2.syear AS syear,
  cs2.cnt AS cnt
FROM cross_sales AS cs1
JOIN cross_sales AS cs2
  ON cs1.cnt >= cs2.cnt
  AND cs1.item_sk = cs2.item_sk
  AND cs1.store_name = cs2.store_name
  AND cs1.store_zip = cs2.store_zip
  AND cs2.syear = 2000
WHERE
  cs1.syear = 1999
ORDER BY
  cs1.product_name,
  cs1.store_name,
  cs2.cnt