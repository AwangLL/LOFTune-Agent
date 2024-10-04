SELECT
  MIN(cn.name) AS producing_company,
  MIN(miidx.info) AS rating,
  MIN(t.title) AS movie_about_winning
FROM company_name AS cn
JOIN company_type AS ct
  ON ct.id = mc.company_type_id AND ct.kind = 'production companies'
JOIN info_type AS it
  ON it.id = miidx.info_type_id AND it.info = 'rating'
JOIN info_type AS it2
  ON it2.id = mi.info_type_id AND it2.info = 'release dates'
JOIN kind_type AS kt
  ON kt.id = t.kind_id AND kt.kind = 'movie'
JOIN movie_companies AS mc
  ON cn.id = mc.company_id
  AND mc.movie_id = mi.movie_id
  AND mc.movie_id = miidx.movie_id
  AND mc.movie_id = t.id
JOIN movie_info AS mi
  ON mi.movie_id = miidx.movie_id AND mi.movie_id = t.id
JOIN movie_info_idx AS miidx
  ON miidx.movie_id = t.id
JOIN title AS t
  ON t.title <> '' AND (
    t.title LIKE '%Champion%' OR t.title LIKE '%Loser%'
  )
WHERE
  cn.country_code = '[us]'