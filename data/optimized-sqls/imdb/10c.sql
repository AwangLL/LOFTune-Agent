SELECT
  MIN(chn.name) AS character,
  MIN(t.title) AS movie_with_american_producer
FROM char_name AS chn
JOIN cast_info AS ci
  ON chn.id = ci.person_role_id
  AND ci.movie_id = mc.movie_id
  AND ci.movie_id = t.id
  AND ci.note LIKE '%(producer)%'
  AND ci.role_id = rt.id
JOIN company_name AS cn
  ON cn.country_code = '[us]' AND cn.id = mc.company_id
JOIN company_type AS ct
  ON ct.id = mc.company_type_id
JOIN movie_companies AS mc
  ON mc.movie_id = t.id, role_type AS rt
JOIN title AS t
  ON t.production_year > 1990