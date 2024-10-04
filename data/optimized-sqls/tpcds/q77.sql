WITH ss AS (
  SELECT
    store.s_store_sk AS s_store_sk,
    SUM(store_sales.ss_ext_sales_price) AS sales,
    SUM(store_sales.ss_net_profit) AS profit
  FROM store_sales AS store_sales
  JOIN date_dim AS date_dim
    ON date_dim.d_date <= (
      CAST('2000-09-02' AS DATE)
    )
    AND date_dim.d_date >= CAST('2000-08-03' AS DATE)
    AND date_dim.d_date_sk = store_sales.ss_sold_date_sk
  JOIN store AS store
    ON store.s_store_sk = store_sales.ss_store_sk
  GROUP BY
    store.s_store_sk
), sr AS (
  SELECT
    store.s_store_sk AS s_store_sk,
    SUM(store_returns.sr_return_amt) AS returns,
    SUM(store_returns.sr_net_loss) AS profit_loss
  FROM store_returns AS store_returns
  JOIN date_dim AS date_dim
    ON date_dim.d_date <= (
      CAST('2000-09-02' AS DATE)
    )
    AND date_dim.d_date >= CAST('2000-08-03' AS DATE)
    AND date_dim.d_date_sk = store_returns.sr_returned_date_sk
  JOIN store AS store
    ON store.s_store_sk = store_returns.sr_store_sk
  GROUP BY
    store.s_store_sk
), cs AS (
  SELECT
    catalog_sales.cs_call_center_sk AS cs_call_center_sk,
    SUM(catalog_sales.cs_ext_sales_price) AS sales,
    SUM(catalog_sales.cs_net_profit) AS profit
  FROM catalog_sales AS catalog_sales
  JOIN date_dim AS date_dim
    ON catalog_sales.cs_sold_date_sk = date_dim.d_date_sk
    AND date_dim.d_date <= (
      CAST('2000-09-02' AS DATE)
    )
    AND date_dim.d_date >= CAST('2000-08-03' AS DATE)
  GROUP BY
    catalog_sales.cs_call_center_sk
), cr AS (
  SELECT
    SUM(catalog_returns.cr_return_amount) AS returns,
    SUM(catalog_returns.cr_net_loss) AS profit_loss
  FROM catalog_returns AS catalog_returns
  JOIN date_dim AS date_dim
    ON catalog_returns.cr_returned_date_sk = date_dim.d_date_sk
    AND date_dim.d_date <= (
      CAST('2000-09-02' AS DATE)
    )
    AND date_dim.d_date >= CAST('2000-08-03' AS DATE)
), ws AS (
  SELECT
    web_page.wp_web_page_sk AS wp_web_page_sk,
    SUM(web_sales.ws_ext_sales_price) AS sales,
    SUM(web_sales.ws_net_profit) AS profit
  FROM web_sales AS web_sales
  JOIN date_dim AS date_dim
    ON date_dim.d_date <= (
      CAST('2000-09-02' AS DATE)
    )
    AND date_dim.d_date >= CAST('2000-08-03' AS DATE)
    AND date_dim.d_date_sk = web_sales.ws_sold_date_sk
  JOIN web_page AS web_page
    ON web_page.wp_web_page_sk = web_sales.ws_web_page_sk
  GROUP BY
    web_page.wp_web_page_sk
), wr AS (
  SELECT
    web_page.wp_web_page_sk AS wp_web_page_sk,
    SUM(web_returns.wr_return_amt) AS returns,
    SUM(web_returns.wr_net_loss) AS profit_loss
  FROM web_returns AS web_returns
  JOIN date_dim AS date_dim
    ON date_dim.d_date <= (
      CAST('2000-09-02' AS DATE)
    )
    AND date_dim.d_date >= CAST('2000-08-03' AS DATE)
    AND date_dim.d_date_sk = web_returns.wr_returned_date_sk
  JOIN web_page AS web_page
    ON web_page.wp_web_page_sk = web_returns.wr_web_page_sk
  GROUP BY
    web_page.wp_web_page_sk
), x AS (
  SELECT
    'store channel' AS channel,
    ss.s_store_sk AS id,
    ss.sales AS sales,
    COALESCE(sr.returns, 0) AS returns,
    ss.profit - COALESCE(sr.profit_loss, 0) AS profit
  FROM ss
  LEFT JOIN sr
    ON sr.s_store_sk = ss.s_store_sk
  UNION ALL
  SELECT
    'catalog channel' AS channel,
    cs.cs_call_center_sk AS id,
    cs.sales AS sales,
    cr.returns AS returns,
    cs.profit - cr.profit_loss AS profit
  FROM cs
  CROSS JOIN cr
  UNION ALL
  SELECT
    'web channel' AS channel,
    ws.wp_web_page_sk AS id,
    ws.sales AS sales,
    COALESCE(wr.returns, 0) AS returns,
    ws.profit - COALESCE(wr.profit_loss, 0) AS profit
  FROM ws
  LEFT JOIN wr
    ON wr.wp_web_page_sk = ws.wp_web_page_sk
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