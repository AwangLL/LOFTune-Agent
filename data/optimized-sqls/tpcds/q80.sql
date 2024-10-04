WITH ssr AS (
  SELECT
    store.s_store_id AS store_id,
    SUM(store_sales.ss_ext_sales_price) AS sales,
    SUM(COALESCE(store_returns.sr_return_amt, 0)) AS returns,
    SUM(store_sales.ss_net_profit - COALESCE(store_returns.sr_net_loss, 0)) AS profit
  FROM store_sales AS store_sales
  JOIN date_dim AS date_dim
    ON date_dim.d_date <= (
      CAST('2000-09-22' AS DATE)
    )
    AND date_dim.d_date >= CAST('2000-08-23' AS DATE)
    AND date_dim.d_date_sk = store_sales.ss_sold_date_sk
  JOIN item AS item
    ON item.i_current_price > 50 AND item.i_item_sk = store_sales.ss_item_sk
  JOIN promotion AS promotion
    ON promotion.p_channel_tv = 'N' AND promotion.p_promo_sk = store_sales.ss_promo_sk
  JOIN store AS store
    ON store.s_store_sk = store_sales.ss_store_sk
  LEFT JOIN store_returns AS store_returns
    ON store_returns.sr_item_sk = store_sales.ss_item_sk
    AND store_returns.sr_ticket_number = store_sales.ss_ticket_number
  GROUP BY
    store.s_store_id
), csr AS (
  SELECT
    catalog_page.cp_catalog_page_id AS catalog_page_id,
    SUM(catalog_sales.cs_ext_sales_price) AS sales,
    SUM(COALESCE(catalog_returns.cr_return_amount, 0)) AS returns,
    SUM(catalog_sales.cs_net_profit - COALESCE(catalog_returns.cr_net_loss, 0)) AS profit
  FROM catalog_sales AS catalog_sales
  JOIN catalog_page AS catalog_page
    ON catalog_page.cp_catalog_page_sk = catalog_sales.cs_catalog_page_sk
  LEFT JOIN catalog_returns AS catalog_returns
    ON catalog_returns.cr_item_sk = catalog_sales.cs_item_sk
    AND catalog_returns.cr_order_number = catalog_sales.cs_order_number
  JOIN date_dim AS date_dim
    ON catalog_sales.cs_sold_date_sk = date_dim.d_date_sk
    AND date_dim.d_date <= (
      CAST('2000-09-22' AS DATE)
    )
    AND date_dim.d_date >= CAST('2000-08-23' AS DATE)
  JOIN item AS item
    ON catalog_sales.cs_item_sk = item.i_item_sk AND item.i_current_price > 50
  JOIN promotion AS promotion
    ON catalog_sales.cs_promo_sk = promotion.p_promo_sk AND promotion.p_channel_tv = 'N'
  GROUP BY
    catalog_page.cp_catalog_page_id
), wsr AS (
  SELECT
    web_site.web_site_id AS web_site_id,
    SUM(web_sales.ws_ext_sales_price) AS sales,
    SUM(COALESCE(web_returns.wr_return_amt, 0)) AS returns,
    SUM(web_sales.ws_net_profit - COALESCE(web_returns.wr_net_loss, 0)) AS profit
  FROM web_sales AS web_sales
  JOIN date_dim AS date_dim
    ON date_dim.d_date <= (
      CAST('2000-09-22' AS DATE)
    )
    AND date_dim.d_date >= CAST('2000-08-23' AS DATE)
    AND date_dim.d_date_sk = web_sales.ws_sold_date_sk
  JOIN item AS item
    ON item.i_current_price > 50 AND item.i_item_sk = web_sales.ws_item_sk
  JOIN promotion AS promotion
    ON promotion.p_channel_tv = 'N' AND promotion.p_promo_sk = web_sales.ws_promo_sk
  LEFT JOIN web_returns AS web_returns
    ON web_returns.wr_item_sk = web_sales.ws_item_sk
    AND web_returns.wr_order_number = web_sales.ws_order_number
  JOIN web_site AS web_site
    ON web_sales.ws_web_site_sk = web_site.web_site_sk
  GROUP BY
    web_site.web_site_id
), x AS (
  SELECT
    'store channel' AS channel,
    CONCAT('store', ssr.store_id) AS id,
    ssr.sales AS sales,
    ssr.returns AS returns,
    ssr.profit AS profit
  FROM ssr
  UNION ALL
  SELECT
    'catalog channel' AS channel,
    CONCAT('catalog_page', csr.catalog_page_id) AS id,
    csr.sales AS sales,
    csr.returns AS returns,
    csr.profit AS profit
  FROM csr
  UNION ALL
  SELECT
    'web channel' AS channel,
    CONCAT('web_site', wsr.web_site_id) AS id,
    wsr.sales AS sales,
    wsr.returns AS returns,
    wsr.profit AS profit
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