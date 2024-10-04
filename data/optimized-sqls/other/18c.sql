SELECT
  MIN(mi.info) AS movie_budget,
  MIN(mi_idx.info) AS movie_votes,
  MIN(t.title) AS movie_title
FROM cast_info AS ci
JOIN name AS n
  ON ci.person_id = n.id AND n.gender = 'm'
JOIN title AS t
  ON ci.movie_id = t.id
JOIN movie_info_idx AS mi_idx
  ON ci.movie_id = mi_idx.movie_id AND mi_idx.movie_id = t.id
JOIN info_type AS it2
  ON it2.id = mi_idx.info_type_id AND it2.info = 'votes'
JOIN movie_info AS mi
  ON ci.movie_id = mi.movie_id
  AND mi.info IN ('Action', 'Crime', 'Horror', 'Sci-Fi', 'Thriller', 'War')
  AND mi.movie_id = mi_idx.movie_id
  AND mi.movie_id = t.id
JOIN info_type AS it1
  ON it1.id = mi.info_type_id AND it1.info = 'genres'
WHERE
  ci.note IN ('(head writer)', '(story editor)', '(story)', '(writer)', '(written by)')