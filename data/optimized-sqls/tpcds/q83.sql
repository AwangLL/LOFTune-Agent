WITH _u_0 AS (
  SELECT
    date_dim.d_week_seq AS d_week_seq
  FROM date_dim AS date_dim
  WHERE
    date_dim.d_date IN ('2000-06-30', '2000-09-27', '2000-11-17')
  GROUP BY
    date_dim.d_week_seq
), _u_1 AS (
  SELECT
    date_dim.d_date AS d_date
  FROM date_dim AS date_dim
  LEFT JOIN _u_0 AS _u_0
    ON `_u_0`.`d_week_seq` = date_dim.d_week_seq
  WHERE
    NOT `_u_0`.`d_week_seq` IS NULL
  GROUP BY
    date_dim.d_date
), sr_items AS (
  SELECT
    item.i_item_id AS item_id,
    SUM(store_returns.sr_return_quantity) AS sr_item_qty
  FROM store_returns AS store_returns
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = store_returns.sr_returned_date_sk
  JOIN item AS item
    ON item.i_item_sk = store_returns.sr_item_sk
  LEFT JOIN _u_1 AS _u_1
    ON `_u_1`.`d_date` = date_dim.d_date
  WHERE
    NOT `_u_1`.`d_date` IS NULL
  GROUP BY
    item.i_item_id
), _u_3 AS (
  SELECT
    date_dim.d_date AS d_date
  FROM date_dim AS date_dim
  LEFT JOIN _u_0 AS _u_2
    ON `_u_2`.`d_week_seq` = date_dim.d_week_seq
  WHERE
    NOT `_u_2`.`d_week_seq` IS NULL
  GROUP BY
    date_dim.d_date
), cr_items AS (
  SELECT
    item.i_item_id AS item_id,
    SUM(catalog_returns.cr_return_quantity) AS cr_item_qty
  FROM catalog_returns AS catalog_returns
  JOIN date_dim AS date_dim
    ON catalog_returns.cr_returned_date_sk = date_dim.d_date_sk
  JOIN item AS item
    ON catalog_returns.cr_item_sk = item.i_item_sk
  LEFT JOIN _u_3 AS _u_3
    ON `_u_3`.`d_date` = date_dim.d_date
  WHERE
    NOT `_u_3`.`d_date` IS NULL
  GROUP BY
    item.i_item_id
), _u_5 AS (
  SELECT
    date_dim.d_date AS d_date
  FROM date_dim AS date_dim
  LEFT JOIN _u_0 AS _u_4
    ON `_u_4`.`d_week_seq` = date_dim.d_week_seq
  WHERE
    NOT `_u_4`.`d_week_seq` IS NULL
  GROUP BY
    date_dim.d_date
), wr_items AS (
  SELECT
    item.i_item_id AS item_id,
    SUM(web_returns.wr_return_quantity) AS wr_item_qty
  FROM web_returns AS web_returns
  JOIN date_dim AS date_dim
    ON date_dim.d_date_sk = web_returns.wr_returned_date_sk
  JOIN item AS item
    ON item.i_item_sk = web_returns.wr_item_sk
  LEFT JOIN _u_5 AS _u_5
    ON `_u_5`.`d_date` = date_dim.d_date
  WHERE
    NOT `_u_5`.`d_date` IS NULL
  GROUP BY
    item.i_item_id
)
SELECT
  sr_items.item_id AS item_id,
  sr_items.sr_item_qty AS sr_item_qty,
  sr_items.sr_item_qty / (
    sr_items.sr_item_qty + cr_items.cr_item_qty + wr_items.wr_item_qty
  ) / 3.0 * 100 AS sr_dev,
  cr_items.cr_item_qty AS cr_item_qty,
  cr_items.cr_item_qty / (
    sr_items.sr_item_qty + cr_items.cr_item_qty + wr_items.wr_item_qty
  ) / 3.0 * 100 AS cr_dev,
  wr_items.wr_item_qty AS wr_item_qty,
  wr_items.wr_item_qty / (
    sr_items.sr_item_qty + cr_items.cr_item_qty + wr_items.wr_item_qty
  ) / 3.0 * 100 AS wr_dev,
  (
    sr_items.sr_item_qty + cr_items.cr_item_qty + wr_items.wr_item_qty
  ) / 3.0 AS average
FROM sr_items
JOIN cr_items
  ON cr_items.item_id = sr_items.item_id
JOIN wr_items
  ON sr_items.item_id = wr_items.item_id
ORDER BY
  sr_items.item_id,
  sr_item_qty
LIMIT 100