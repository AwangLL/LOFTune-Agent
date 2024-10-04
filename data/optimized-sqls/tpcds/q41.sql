SELECT DISTINCT
  i1.i_product_name AS i_product_name
FROM item AS i1
WHERE
  (
    SELECT
      COUNT(*) AS item_cnt
    FROM item AS item
    WHERE
      (
        (
          (
            item.i_category = 'Men'
            AND (
              item.i_color = 'cornflower' OR item.i_color = 'light'
            )
            AND (
              item.i_size = 'extra large' OR item.i_size = 'medium'
            )
            AND (
              item.i_units = 'Box' OR item.i_units = 'Pound'
            )
          )
          OR (
            item.i_category = 'Men'
            AND (
              item.i_color = 'deep' OR item.i_color = 'floral'
            )
            AND (
              item.i_size = 'large' OR item.i_size = 'petite'
            )
            AND (
              item.i_units = 'Dozen' OR item.i_units = 'N/A'
            )
          )
          OR (
            item.i_category = 'Women'
            AND (
              item.i_color = 'brown' OR item.i_color = 'honeydew'
            )
            AND (
              item.i_size = 'N/A' OR item.i_size = 'small'
            )
            AND (
              item.i_units = 'Bunch' OR item.i_units = 'Ton'
            )
          )
          OR (
            item.i_category = 'Women'
            AND (
              item.i_color = 'khaki' OR item.i_color = 'powder'
            )
            AND (
              item.i_size = 'extra large' OR item.i_size = 'medium'
            )
            AND (
              item.i_units = 'Ounce' OR item.i_units = 'Oz'
            )
          )
        )
        AND i1.i_manufact = item.i_manufact
      )
      OR (
        (
          (
            item.i_category = 'Men'
            AND (
              item.i_color = 'forest' OR item.i_color = 'ghost'
            )
            AND (
              item.i_size = 'extra large' OR item.i_size = 'medium'
            )
            AND (
              item.i_units = 'Bundle' OR item.i_units = 'Lb'
            )
          )
          OR (
            item.i_category = 'Men'
            AND (
              item.i_color = 'frosted' OR item.i_color = 'orange'
            )
            AND (
              item.i_size = 'large' OR item.i_size = 'petite'
            )
            AND (
              item.i_units = 'Each' OR item.i_units = 'Tbl'
            )
          )
          OR (
            item.i_category = 'Women'
            AND (
              item.i_color = 'cyan' OR item.i_color = 'papaya'
            )
            AND (
              item.i_size = 'N/A' OR item.i_size = 'small'
            )
            AND (
              item.i_units = 'Cup' OR item.i_units = 'Dram'
            )
          )
          OR (
            item.i_category = 'Women'
            AND (
              item.i_color = 'midnight' OR item.i_color = 'snow'
            )
            AND (
              item.i_size = 'extra large' OR item.i_size = 'medium'
            )
            AND (
              item.i_units = 'Gross' OR item.i_units = 'Pallet'
            )
          )
        )
        AND i1.i_manufact = item.i_manufact
      )
  ) > 0
  AND i1.i_manufact_id <= 778
  AND i1.i_manufact_id >= 738
ORDER BY
  i1.i_product_name
LIMIT 100