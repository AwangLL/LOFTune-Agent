WITH salesreturns AS (
  SELECT
    store_sales.ss_store_sk AS store_sk,
    store_sales.ss_sold_date_sk AS date_sk,
    store_sales.ss_ext_sales_price AS sales_price,
    store_sales.ss_net_profit AS profit,
    CAST(0 AS DECIMAL(7, 2)) AS return_amt,
    CAST(0 AS DECIMAL(7, 2)) AS net_loss
  FROM store_sales AS store_sales
  UNION ALL
  SELECT
    store_returns.sr_store_sk AS store_sk,
    store_returns.sr_returned_date_sk AS date_sk,
    CAST(0 AS DECIMAL(7, 2)) AS sales_price,
    CAST(0 AS DECIMAL(7, 2)) AS profit,
    store_returns.sr_return_amt AS return_amt,
    store_returns.sr_net_loss AS net_loss
  FROM store_returns AS store_returns
), ssr AS (
  SELECT
    store.s_store_id AS s_store_id,
    SUM(salesreturns.sales_price) AS sales,
    SUM(salesreturns.profit) AS profit,
    SUM(salesreturns.return_amt) AS returns,
    SUM(salesreturns.net_loss) AS profit_loss
  FROM salesreturns AS salesreturns
  JOIN date_dim AS date_dim
    ON date_dim.d_date <= (
      CAST('2000-09-06' AS DATE)
    )
    AND date_dim.d_date >= CAST('2000-08-23' AS DATE)
    AND date_dim.d_date_sk = salesreturns.date_sk
  JOIN store AS store
    ON salesreturns.store_sk = store.s_store_sk
  GROUP BY
    store.s_store_id
), salesreturns_2 AS (
  SELECT
    catalog_sales.cs_catalog_page_sk AS page_sk,
    catalog_sales.cs_sold_date_sk AS date_sk,
    catalog_sales.cs_ext_sales_price AS sales_price,
    catalog_sales.cs_net_profit AS profit,
    CAST(0 AS DECIMAL(7, 2)) AS return_amt,
    CAST(0 AS DECIMAL(7, 2)) AS net_loss
  FROM catalog_sales AS catalog_sales
  UNION ALL
  SELECT
    catalog_returns.cr_catalog_page_sk AS page_sk,
    catalog_returns.cr_returned_date_sk AS date_sk,
    CAST(0 AS DECIMAL(7, 2)) AS sales_price,
    CAST(0 AS DECIMAL(7, 2)) AS profit,
    catalog_returns.cr_return_amount AS return_amt,
    catalog_returns.cr_net_loss AS net_loss
  FROM catalog_returns AS catalog_returns
), csr AS (
  SELECT
    catalog_page.cp_catalog_page_id AS cp_catalog_page_id,
    SUM(salesreturns.sales_price) AS sales,
    SUM(salesreturns.profit) AS profit,
    SUM(salesreturns.return_amt) AS returns,
    SUM(salesreturns.net_loss) AS profit_loss
  FROM salesreturns_2 AS salesreturns
  JOIN catalog_page AS catalog_page
    ON catalog_page.cp_catalog_page_sk = salesreturns.page_sk
  JOIN date_dim AS date_dim
    ON date_dim.d_date <= (
      CAST('2000-09-06' AS DATE)
    )
    AND date_dim.d_date >= CAST('2000-08-23' AS DATE)
    AND date_dim.d_date_sk = salesreturns.date_sk
  GROUP BY
    catalog_page.cp_catalog_page_id
), salesreturns_3 AS (
  SELECT
    web_sales.ws_web_site_sk AS wsr_web_site_sk,
    web_sales.ws_sold_date_sk AS date_sk,
    web_sales.ws_ext_sales_price AS sales_price,
    web_sales.ws_net_profit AS profit,
    CAST(0 AS DECIMAL(7, 2)) AS return_amt,
    CAST(0 AS DECIMAL(7, 2)) AS net_loss
  FROM web_sales AS web_sales
  UNION ALL
  SELECT
    web_sales.ws_web_site_sk AS wsr_web_site_sk,
    web_returns.wr_returned_date_sk AS date_sk,
    CAST(0 AS DECIMAL(7, 2)) AS sales_price,
    CAST(0 AS DECIMAL(7, 2)) AS profit,
    web_returns.wr_return_amt AS return_amt,
    web_returns.wr_net_loss AS net_loss
  FROM web_returns AS web_returns
  LEFT JOIN web_sales AS web_sales
    ON web_returns.wr_item_sk = web_sales.ws_item_sk
    AND web_returns.wr_order_number = web_sales.ws_order_number
), wsr AS (
  SELECT
    web_site.web_site_id AS web_site_id,
    SUM(salesreturns.sales_price) AS sales,
    SUM(salesreturns.profit) AS profit,
    SUM(salesreturns.return_amt) AS returns,
    SUM(salesreturns.net_loss) AS profit_loss
  FROM salesreturns_3 AS salesreturns
  JOIN date_dim AS date_dim
    ON date_dim.d_date <= (
      CAST('2000-09-06' AS DATE)
    )
    AND date_dim.d_date >= CAST('2000-08-23' AS DATE)
    AND date_dim.d_date_sk = salesreturns.date_sk
  JOIN web_site AS web_site
    ON salesreturns.wsr_web_site_sk = web_site.web_site_sk
  GROUP BY
    web_site.web_site_id
), x AS (
  SELECT
    'store channel' AS channel,
    CONCAT('store', ssr.s_store_id) AS id,
    ssr.sales AS sales,
    ssr.returns AS returns,
    ssr.profit - ssr.profit_loss AS profit
  FROM ssr
  UNION ALL
  SELECT
    'catalog channel' AS channel,
    CONCAT('catalog_page', csr.cp_catalog_page_id) AS id,
    csr.sales AS sales,
    csr.returns AS returns,
    csr.profit - csr.profit_loss AS profit
  FROM csr
  UNION ALL
  SELECT
    'web channel' AS channel,
    CONCAT('web_site', wsr.web_site_id) AS id,
    wsr.sales AS sales,
    wsr.returns AS returns,
    wsr.profit - wsr.profit_loss AS profit
  FROM wsr
)
SELECT
  x.channel AS channel,
  x.id AS id,
  SUM(x.sales) AS sales,
  SUM(x.returns) AS returns,
  SUM(x.profit) AS profit
FROM x AS x
GROUP BY
ROLLUP (
  x.channel,
  x.id
)
ORDER BY
  channel,
  id
LIMIT 100