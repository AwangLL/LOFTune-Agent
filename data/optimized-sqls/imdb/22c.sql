SELECT
  MIN(cn.name) AS movie_company,
  MIN(mi_idx.info) AS rating,
  MIN(t.title) AS western_violent_movie
FROM company_name AS cn
JOIN company_type AS ct
  ON ct.id = mc.company_type_id
JOIN info_type AS it1
  ON it1.id = mi.info_type_id AND it1.info = 'countries'
JOIN info_type AS it2
  ON it2.id = mi_idx.info_type_id AND it2.info = 'rating'
JOIN keyword AS k
  ON k.id = mk.keyword_id
  AND k.keyword IN ('blood', 'murder', 'murder-in-title', 'violence')
JOIN kind_type AS kt
  ON kt.id = t.kind_id AND kt.kind IN ('episode', 'movie')
JOIN movie_companies AS mc
  ON NOT mc.note LIKE '%(USA)%'
  AND cn.id = mc.company_id
  AND mc.movie_id = mi.movie_id
  AND mc.movie_id = mi_idx.movie_id
  AND mc.movie_id = mk.movie_id
  AND mc.movie_id = t.id
  AND mc.note LIKE '%(200%)%'
JOIN movie_info AS mi
  ON mi.info IN ('American', 'Danish', 'Denmark', 'German', 'Germany', 'Norway', 'Norwegian', 'Sweden', 'Swedish', 'USA')
  AND mi.movie_id = mi_idx.movie_id
  AND mi.movie_id = mk.movie_id
  AND mi.movie_id = t.id
JOIN movie_info_idx AS mi_idx
  ON mi_idx.info < '8.5' AND mi_idx.movie_id = mk.movie_id AND mi_idx.movie_id = t.id
JOIN movie_keyword AS mk
  ON mk.movie_id = t.id
JOIN title AS t
  ON t.production_year > 2005
WHERE
  cn.country_code <> '[us]'