SELECT
  MIN(cn.name) AS movie_company,
  MIN(mi_idx.info) AS rating,
  MIN(t.title) AS complete_euro_dark_movie
FROM complete_cast AS cc
JOIN comp_cast_type AS cct1
  ON cc.subject_id = cct1.id AND cct1.kind = 'cast'
JOIN comp_cast_type AS cct2
  ON cc.status_id = cct2.id AND cct2.kind = 'complete'
JOIN title AS t
  ON cc.movie_id = t.id AND t.production_year > 2005
JOIN kind_type AS kt
  ON kt.id = t.kind_id AND kt.kind IN ('episode', 'movie')
JOIN movie_keyword AS mk
  ON cc.movie_id = mk.movie_id AND mk.movie_id = t.id
JOIN keyword AS k
  ON k.id = mk.keyword_id
  AND k.keyword IN ('blood', 'murder', 'murder-in-title', 'violence')
JOIN movie_info_idx AS mi_idx
  ON cc.movie_id = mi_idx.movie_id
  AND mi_idx.info < '8.5'
  AND mi_idx.movie_id = mk.movie_id
  AND mi_idx.movie_id = t.id
JOIN info_type AS it2
  ON it2.id = mi_idx.info_type_id AND it2.info = 'rating'
JOIN movie_info AS mi
  ON cc.movie_id = mi.movie_id
  AND mi.info IN ('American', 'Danish', 'Denmark', 'German', 'Germany', 'Norway', 'Norwegian', 'Sweden', 'Swedish', 'USA')
  AND mi.movie_id = mi_idx.movie_id
  AND mi.movie_id = mk.movie_id
  AND mi.movie_id = t.id
JOIN info_type AS it1
  ON it1.id = mi.info_type_id AND it1.info = 'countries'
JOIN movie_companies AS mc
  ON NOT mc.note LIKE '%(USA)%'
  AND cc.movie_id = mc.movie_id
  AND mc.movie_id = mi.movie_id
  AND mc.movie_id = mi_idx.movie_id
  AND mc.movie_id = mk.movie_id
  AND mc.movie_id = t.id
  AND mc.note LIKE '%(200%)%'
JOIN company_name AS cn
  ON cn.country_code <> '[us]' AND cn.id = mc.company_id
JOIN company_type AS ct
  ON ct.id = mc.company_type_id