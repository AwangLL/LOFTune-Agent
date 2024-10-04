SELECT
  MIN(an1.name) AS actress_pseudonym,
  MIN(t.title) AS japanese_movie_dubbed
FROM aka_name AS an1
JOIN cast_info AS ci
  ON an1.person_id = ci.person_id
  AND ci.movie_id = mc.movie_id
  AND ci.movie_id = t.id
  AND ci.note = '(voice: English version)'
  AND ci.person_id = n1.id
  AND ci.role_id = rt.id
JOIN company_name AS cn
  ON cn.country_code = '[jp]' AND cn.id = mc.company_id
JOIN movie_companies AS mc
  ON NOT mc.note LIKE '%(USA)%' AND mc.movie_id = t.id AND mc.note LIKE '%(Japan)%'
JOIN name AS n1
  ON NOT n1.name LIKE '%Yu%' AND an1.person_id = n1.id AND n1.name LIKE '%Yo%'
JOIN role_type AS rt
  ON rt.role = 'actress', title AS t