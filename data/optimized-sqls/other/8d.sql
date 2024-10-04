SELECT
  MIN(an1.name) AS costume_designer_pseudo,
  MIN(t.title) AS movie_with_costumes
FROM aka_name AS an1
JOIN cast_info AS ci
  ON an1.person_id = ci.person_id
  AND ci.movie_id = mc.movie_id
  AND ci.movie_id = t.id
  AND ci.person_id = n1.id
  AND ci.role_id = rt.id
JOIN company_name AS cn
  ON cn.country_code = '[us]' AND cn.id = mc.company_id
JOIN movie_companies AS mc
  ON mc.movie_id = t.id
JOIN name AS n1
  ON an1.person_id = n1.id
JOIN role_type AS rt
  ON rt.role = 'costume designer', title AS t