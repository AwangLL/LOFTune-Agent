SELECT
  MIN(cn1.name) AS first_company,
  MIN(cn2.name) AS second_company,
  MIN(mi_idx1.info) AS first_rating,
  MIN(mi_idx2.info) AS second_rating,
  MIN(t1.title) AS first_movie,
  MIN(t2.title) AS second_movie
FROM company_name AS cn1
JOIN company_name AS cn2
  ON cn2.id = mc2.company_id
JOIN info_type AS it1
  ON it1.id = mi_idx1.info_type_id AND it1.info = 'rating'
JOIN info_type AS it2
  ON it2.id = mi_idx2.info_type_id AND it2.info = 'rating'
JOIN kind_type AS kt1
  ON kt1.id = t1.kind_id AND kt1.kind IN ('tv series')
JOIN kind_type AS kt2
  ON kt2.id = t2.kind_id AND kt2.kind IN ('tv series')
JOIN link_type AS lt
  ON lt.id = ml.link_type_id AND lt.link IN ('followed by', 'follows', 'sequel')
JOIN movie_companies AS mc1
  ON cn1.id = mc1.company_id
  AND mc1.movie_id = mi_idx1.movie_id
  AND mc1.movie_id = ml.movie_id
  AND mc1.movie_id = t1.id
JOIN movie_companies AS mc2
  ON mc2.movie_id = mi_idx2.movie_id
  AND mc2.movie_id = ml.linked_movie_id
  AND mc2.movie_id = t2.id
JOIN movie_info_idx AS mi_idx1
  ON mi_idx1.movie_id = ml.movie_id AND mi_idx1.movie_id = t1.id
JOIN movie_info_idx AS mi_idx2
  ON mi_idx2.info < '3.0'
  AND mi_idx2.movie_id = ml.linked_movie_id
  AND mi_idx2.movie_id = t2.id
JOIN movie_link AS ml
  ON ml.linked_movie_id = t2.id AND ml.movie_id = t1.id, title AS t1
JOIN title AS t2
  ON t2.production_year <= 2008 AND t2.production_year >= 2005
WHERE
  cn1.country_code = '[us]'