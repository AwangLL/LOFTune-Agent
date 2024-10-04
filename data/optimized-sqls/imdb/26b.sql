SELECT
  MIN(chn.name) AS character_name,
  MIN(mi_idx.info) AS rating,
  MIN(t.title) AS complete_hero_movie
FROM complete_cast AS cc
JOIN comp_cast_type AS cct1
  ON cc.subject_id = cct1.id AND cct1.kind = 'cast'
JOIN comp_cast_type AS cct2
  ON cc.status_id = cct2.id AND cct2.kind LIKE '%complete%'
JOIN title AS t
  ON cc.movie_id = t.id AND t.production_year > 2005
JOIN kind_type AS kt
  ON kt.id = t.kind_id AND kt.kind = 'movie'
JOIN movie_keyword AS mk
  ON cc.movie_id = mk.movie_id AND mk.movie_id = t.id
JOIN keyword AS k
  ON k.id = mk.keyword_id
  AND k.keyword IN ('based-on-comic', 'fight', 'marvel-comics', 'superhero')
JOIN movie_info_idx AS mi_idx
  ON cc.movie_id = mi_idx.movie_id
  AND mi_idx.info > '8.0'
  AND mi_idx.movie_id = mk.movie_id
  AND mi_idx.movie_id = t.id
JOIN cast_info AS ci
  ON cc.movie_id = ci.movie_id
  AND ci.movie_id = mi_idx.movie_id
  AND ci.movie_id = mk.movie_id
  AND ci.movie_id = t.id
JOIN info_type AS it2
  ON it2.id = mi_idx.info_type_id AND it2.info = 'rating'
JOIN char_name AS chn
  ON NOT chn.name IS NULL
  AND chn.id = ci.person_role_id
  AND (
    chn.name LIKE '%Man%' OR chn.name LIKE '%man%'
  )
JOIN name AS n
  ON ci.person_id = n.id