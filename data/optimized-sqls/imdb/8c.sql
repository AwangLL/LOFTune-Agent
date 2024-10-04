SELECT
  MIN(a1.name) AS writer_pseudo_name,
  MIN(t.title) AS movie_title
FROM aka_name AS a1
JOIN cast_info AS ci
  ON a1.person_id = ci.person_id
  AND ci.movie_id = mc.movie_id
  AND ci.movie_id = t.id
  AND ci.person_id = n1.id
  AND ci.role_id = rt.id
JOIN company_name AS cn
  ON cn.country_code = '[us]' AND cn.id = mc.company_id
JOIN movie_companies AS mc
  ON mc.movie_id = t.id
JOIN name AS n1
  ON a1.person_id = n1.id
JOIN role_type AS rt
  ON rt.role = 'writer', title AS t