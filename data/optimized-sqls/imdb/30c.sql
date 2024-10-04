SELECT
  MIN(mi.info) AS movie_budget,
  MIN(mi_idx.info) AS movie_votes,
  MIN(n.name) AS writer,
  MIN(t.title) AS complete_violent_movie
FROM complete_cast AS cc
JOIN comp_cast_type AS cct1
  ON cc.subject_id = cct1.id AND cct1.kind = 'cast'
JOIN comp_cast_type AS cct2
  ON cc.status_id = cct2.id AND cct2.kind = 'complete+verified'
JOIN title AS t
  ON cc.movie_id = t.id
JOIN movie_keyword AS mk
  ON cc.movie_id = mk.movie_id AND mk.movie_id = t.id
JOIN keyword AS k
  ON k.id = mk.keyword_id
  AND k.keyword IN ('blood', 'death', 'female-nudity', 'gore', 'hospital', 'murder', 'violence')
JOIN movie_info_idx AS mi_idx
  ON cc.movie_id = mi_idx.movie_id AND mi_idx.movie_id = mk.movie_id AND mi_idx.movie_id = t.id
JOIN info_type AS it2
  ON it2.id = mi_idx.info_type_id AND it2.info = 'votes'
JOIN movie_info AS mi
  ON cc.movie_id = mi.movie_id
  AND mi.info IN ('Action', 'Crime', 'Horror', 'Sci-Fi', 'Thriller', 'War')
  AND mi.movie_id = mi_idx.movie_id
  AND mi.movie_id = mk.movie_id
  AND mi.movie_id = t.id
JOIN cast_info AS ci
  ON cc.movie_id = ci.movie_id
  AND ci.movie_id = mi.movie_id
  AND ci.movie_id = mi_idx.movie_id
  AND ci.movie_id = mk.movie_id
  AND ci.movie_id = t.id
  AND ci.note IN ('(head writer)', '(story editor)', '(story)', '(writer)', '(written by)')
JOIN info_type AS it1
  ON it1.id = mi.info_type_id AND it1.info = 'genres'
JOIN name AS n
  ON ci.person_id = n.id AND n.gender = 'm'