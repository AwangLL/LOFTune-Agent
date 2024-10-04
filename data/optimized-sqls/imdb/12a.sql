SELECT
  MIN(cn.name) AS movie_company,
  MIN(mi_idx.info) AS rating,
  MIN(t.title) AS drama_horror_movie
FROM company_name AS cn
JOIN company_type AS ct
  ON ct.id = mc.company_type_id AND ct.kind = 'production companies'
JOIN info_type AS it1
  ON it1.id = mi.info_type_id AND it1.info = 'genres'
JOIN info_type AS it2
  ON it2.id = mi_idx.info_type_id AND it2.info = 'rating'
JOIN movie_companies AS mc
  ON cn.id = mc.company_id
  AND mc.movie_id = mi.movie_id
  AND mc.movie_id = mi_idx.movie_id
  AND mc.movie_id = t.id
JOIN movie_info AS mi
  ON mi.info IN ('Drama', 'Horror') AND mi.movie_id = mi_idx.movie_id AND mi.movie_id = t.id
JOIN movie_info_idx AS mi_idx
  ON mi_idx.info > '8.0' AND mi_idx.movie_id = t.id
JOIN title AS t
  ON t.production_year <= 2008 AND t.production_year >= 2005
WHERE
  cn.country_code = '[us]'