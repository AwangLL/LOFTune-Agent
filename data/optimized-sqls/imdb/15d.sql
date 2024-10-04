SELECT
  MIN(at.title) AS aka_title,
  MIN(t.title) AS internet_movie_title
FROM aka_title AS at
JOIN title AS t
  ON at.movie_id = t.id AND t.production_year > 1990
JOIN movie_keyword AS mk
  ON at.movie_id = mk.movie_id AND mk.movie_id = t.id
JOIN keyword AS k
  ON k.id = mk.keyword_id
JOIN movie_info AS mi
  ON at.movie_id = mi.movie_id
  AND mi.movie_id = mk.movie_id
  AND mi.movie_id = t.id
  AND mi.note LIKE '%internet%'
JOIN info_type AS it1
  ON it1.id = mi.info_type_id AND it1.info = 'release dates'
JOIN movie_companies AS mc
  ON at.movie_id = mc.movie_id
  AND mc.movie_id = mi.movie_id
  AND mc.movie_id = mk.movie_id
  AND mc.movie_id = t.id
JOIN company_name AS cn
  ON cn.country_code = '[us]' AND cn.id = mc.company_id
JOIN company_type AS ct
  ON ct.id = mc.company_type_id