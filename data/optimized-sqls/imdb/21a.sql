SELECT
  MIN(cn.name) AS company_name,
  MIN(lt.link) AS link_type,
  MIN(t.title) AS western_follow_up
FROM company_name AS cn
JOIN company_type AS ct
  ON ct.id = mc.company_type_id AND ct.kind = 'production companies'
JOIN keyword AS k
  ON k.id = mk.keyword_id AND k.keyword = 'sequel'
JOIN link_type AS lt
  ON lt.id = ml.link_type_id AND lt.link LIKE '%follow%'
JOIN movie_companies AS mc
  ON cn.id = mc.company_id
  AND mc.movie_id = mi.movie_id
  AND mc.movie_id = mk.movie_id
  AND mc.movie_id = ml.movie_id
  AND mc.movie_id = t.id
  AND mc.note IS NULL
JOIN movie_info AS mi
  ON mi.info IN ('Denish', 'Denmark', 'German', 'Germany', 'Norway', 'Norwegian', 'Sweden', 'Swedish')
  AND mi.movie_id = mk.movie_id
  AND mi.movie_id = ml.movie_id
  AND mi.movie_id = t.id
JOIN movie_keyword AS mk
  ON mk.movie_id = ml.movie_id AND mk.movie_id = t.id
JOIN movie_link AS ml
  ON ml.movie_id = t.id
JOIN title AS t
  ON t.production_year <= 2000 AND t.production_year >= 1950
WHERE
  cn.country_code <> '[pl]' AND (
    cn.name LIKE '%Film%' OR cn.name LIKE '%Warner%'
  )