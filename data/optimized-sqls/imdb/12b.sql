SELECT
  MIN(mi.info) AS budget,
  MIN(t.title) AS unsuccsessful_movie
FROM company_name AS cn
JOIN company_type AS ct
  ON NOT ct.kind IS NULL
  AND ct.id = mc.company_type_id
  AND (
    ct.kind = 'distributors' OR ct.kind = 'production companies'
  )
JOIN info_type AS it1
  ON it1.id = mi.info_type_id AND it1.info = 'budget'
JOIN info_type AS it2
  ON it2.id = mi_idx.info_type_id AND it2.info = 'bottom 10 rank'
JOIN movie_companies AS mc
  ON cn.id = mc.company_id
  AND mc.movie_id = mi.movie_id
  AND mc.movie_id = mi_idx.movie_id
  AND mc.movie_id = t.id
JOIN movie_info AS mi
  ON mi.movie_id = mi_idx.movie_id AND mi.movie_id = t.id
JOIN movie_info_idx AS mi_idx
  ON mi_idx.movie_id = t.id
JOIN title AS t
  ON t.production_year > 2000 AND (
    t.title LIKE '%Movie%' OR t.title LIKE 'Birdemic%'
  )
WHERE
  cn.country_code = '[us]'