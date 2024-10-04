SELECT
  MIN(chn.name) AS character,
  MIN(t.title) AS russian_mov_with_actor_producer
FROM char_name AS chn
JOIN cast_info AS ci
  ON chn.id = ci.person_role_id
  AND ci.movie_id = mc.movie_id
  AND ci.movie_id = t.id
  AND ci.note LIKE '%(producer)%'
  AND ci.role_id = rt.id
JOIN company_name AS cn
  ON cn.country_code = '[ru]' AND cn.id = mc.company_id
JOIN company_type AS ct
  ON ct.id = mc.company_type_id
JOIN movie_companies AS mc
  ON mc.movie_id = t.id
JOIN role_type AS rt
  ON rt.role = 'actor'
JOIN title AS t
  ON t.production_year > 2010