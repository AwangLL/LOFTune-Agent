SELECT
  customer.c_customer_id AS customer_id,
  CONCAT(customer.c_last_name, ', ', customer.c_first_name) AS customername
FROM customer AS customer
JOIN customer_address AS customer_address
  ON customer.c_current_addr_sk = customer_address.ca_address_sk
  AND customer_address.ca_city <> 'Edgewood'
JOIN customer_demographics AS customer_demographics
  ON customer.c_current_cdemo_sk = customer_demographics.cd_demo_sk
JOIN household_demographics AS household_demographics
  ON customer.c_current_hdemo_sk = household_demographics.hd_demo_sk
JOIN income_band AS income_band
  ON household_demographics.hd_income_band_sk = income_band.ib_income_band_sk
  AND income_band.ib_lower_bound > 10000
  AND income_band.ib_upper_bound < 70000
JOIN store_returns AS store_returns
  ON customer_demographics.cd_demo_sk = store_returns.sr_cdemo_sk
ORDER BY
  customer.c_customer_id
LIMIT 100