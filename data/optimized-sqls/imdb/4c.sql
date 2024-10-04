SELECT
  MIN(mi_idx.info) AS rating,
  MIN(t.title) AS movie_title
FROM info_type AS it
JOIN keyword AS k
  ON k.id = mk.keyword_id AND k.keyword LIKE '%sequel%'
JOIN movie_info_idx AS mi_idx
  ON it.id = mi_idx.info_type_id
  AND mi_idx.info > '2.0'
  AND mi_idx.movie_id = mk.movie_id
  AND mi_idx.movie_id = t.id
JOIN movie_keyword AS mk
  ON mk.movie_id = t.id
JOIN title AS t
  ON t.production_year > 1990
WHERE
  it.info = 'rating'