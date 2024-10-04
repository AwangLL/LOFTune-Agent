SELECT
  call_center.cc_call_center_id AS call_center,
  call_center.cc_name AS call_center_name,
  call_center.cc_manager AS manager,
  SUM(catalog_returns.cr_net_loss) AS returns_loss
FROM call_center AS call_center
JOIN household_demographics AS household_demographics
  ON household_demographics.hd_buy_potential LIKE 'Unknown%'
JOIN customer AS customer
  ON customer.c_current_hdemo_sk = household_demographics.hd_demo_sk
JOIN catalog_returns AS catalog_returns
  ON call_center.cc_call_center_sk = catalog_returns.cr_call_center_sk
  AND catalog_returns.cr_returning_customer_sk = customer.c_customer_sk
JOIN customer_address AS customer_address
  ON customer.c_current_addr_sk = customer_address.ca_address_sk
  AND customer_address.ca_gmt_offset = -7
JOIN customer_demographics AS customer_demographics
  ON customer.c_current_cdemo_sk = customer_demographics.cd_demo_sk
  AND (
    customer_demographics.cd_education_status = 'Advanced Degree'
    OR customer_demographics.cd_education_status = 'Unknown'
  )
  AND (
    customer_demographics.cd_education_status = 'Advanced Degree'
    OR customer_demographics.cd_marital_status = 'M'
  )
  AND (
    customer_demographics.cd_education_status = 'Unknown'
    OR customer_demographics.cd_marital_status = 'W'
  )
  AND (
    customer_demographics.cd_marital_status = 'M'
    OR customer_demographics.cd_marital_status = 'W'
  )
JOIN date_dim AS date_dim
  ON catalog_returns.cr_returned_date_sk = date_dim.d_date_sk
  AND date_dim.d_moy = 11
  AND date_dim.d_year = 1998
GROUP BY
  call_center.cc_call_center_id,
  call_center.cc_name,
  call_center.cc_manager,
  customer_demographics.cd_marital_status,
  customer_demographics.cd_education_status
ORDER BY
  returns_loss DESC