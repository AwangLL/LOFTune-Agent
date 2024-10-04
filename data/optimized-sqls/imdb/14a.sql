SELECT
  MIN(mi_idx.info) AS rating,
  MIN(t.title) AS northern_dark_movie
FROM info_type AS it1
JOIN info_type AS it2
  ON it2.id = mi_idx.info_type_id AND it2.info = 'rating'
JOIN keyword AS k
  ON k.id = mk.keyword_id
  AND k.keyword IN ('blood', 'murder', 'murder-in-title', 'violence')
JOIN kind_type AS kt
  ON kt.id = t.kind_id AND kt.kind = 'movie'
JOIN movie_info AS mi
  ON it1.id = mi.info_type_id
  AND mi.info IN ('American', 'Denish', 'Denmark', 'German', 'Germany', 'Norway', 'Norwegian', 'Sweden', 'Swedish', 'USA')
  AND mi.movie_id = mi_idx.movie_id
  AND mi.movie_id = mk.movie_id
  AND mi.movie_id = t.id
JOIN movie_info_idx AS mi_idx
  ON mi_idx.info < '8.5' AND mi_idx.movie_id = mk.movie_id AND mi_idx.movie_id = t.id
JOIN movie_keyword AS mk
  ON mk.movie_id = t.id
JOIN title AS t
  ON t.production_year > 2010
WHERE
  it1.info = 'countries'