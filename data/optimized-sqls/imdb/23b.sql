SELECT
  MIN(kt.kind) AS movie_kind,
  MIN(t.title) AS complete_nerdy_internet_movie
FROM complete_cast AS cc
JOIN comp_cast_type AS cct1
  ON cc.status_id = cct1.id AND cct1.kind = 'complete+verified'
JOIN title AS t
  ON cc.movie_id = t.id AND t.production_year > 2000
JOIN kind_type AS kt
  ON kt.id = t.kind_id AND kt.kind IN ('movie')
JOIN movie_keyword AS mk
  ON cc.movie_id = mk.movie_id AND mk.movie_id = t.id
JOIN keyword AS k
  ON k.id = mk.keyword_id AND k.keyword IN ('alienation', 'dignity', 'loner', 'nerd')
JOIN movie_info AS mi
  ON cc.movie_id = mi.movie_id
  AND mi.info LIKE 'USA:% 200%'
  AND mi.movie_id = mk.movie_id
  AND mi.movie_id = t.id
  AND mi.note LIKE '%internet%'
JOIN info_type AS it1
  ON it1.id = mi.info_type_id AND it1.info = 'release dates'
JOIN movie_companies AS mc
  ON cc.movie_id = mc.movie_id
  AND mc.movie_id = mi.movie_id
  AND mc.movie_id = mk.movie_id
  AND mc.movie_id = t.id
JOIN company_name AS cn
  ON cn.country_code = '[us]' AND cn.id = mc.company_id
JOIN company_type AS ct
  ON ct.id = mc.company_type_id