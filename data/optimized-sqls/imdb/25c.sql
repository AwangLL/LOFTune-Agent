SELECT
  MIN(mi.info) AS movie_budget,
  MIN(mi_idx.info) AS movie_votes,
  MIN(n.name) AS male_writer,
  MIN(t.title) AS violent_movie_title
FROM cast_info AS ci
JOIN name AS n
  ON ci.person_id = n.id AND n.gender = 'm'
JOIN title AS t
  ON ci.movie_id = t.id
JOIN movie_keyword AS mk
  ON ci.movie_id = mk.movie_id AND mk.movie_id = t.id
JOIN keyword AS k
  ON k.id = mk.keyword_id
  AND k.keyword IN ('blood', 'death', 'female-nudity', 'gore', 'hospital', 'murder', 'violence')
JOIN movie_info_idx AS mi_idx
  ON ci.movie_id = mi_idx.movie_id AND mi_idx.movie_id = mk.movie_id AND mi_idx.movie_id = t.id
JOIN info_type AS it2
  ON it2.id = mi_idx.info_type_id AND it2.info = 'votes'
JOIN movie_info AS mi
  ON ci.movie_id = mi.movie_id
  AND mi.info IN ('Action', 'Crime', 'Horror', 'Sci-Fi', 'Thriller', 'War')
  AND mi.movie_id = mi_idx.movie_id
  AND mi.movie_id = mk.movie_id
  AND mi.movie_id = t.id
JOIN info_type AS it1
  ON it1.id = mi.info_type_id AND it1.info = 'genres'
WHERE
  ci.note IN ('(head writer)', '(story editor)', '(story)', '(writer)', '(written by)')