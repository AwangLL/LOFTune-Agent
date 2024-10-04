SELECT
  MIN(an.name) AS alternative_name,
  MIN(chn.name) AS voiced_char_name,
  MIN(n.name) AS voicing_actress,
  MIN(t.title) AS american_movie
FROM aka_name AS an
JOIN char_name AS chn
  ON chn.id = ci.person_role_id
JOIN cast_info AS ci
  ON an.person_id = ci.person_id
  AND ci.movie_id = mc.movie_id
  AND ci.movie_id = t.id
  AND ci.note IN ('(voice)', '(voice) (uncredited)', '(voice: English version)', '(voice: Japanese version)')
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
JOIN company_name AS cn
  ON cn.country_code = '[us]' AND cn.id = mc.company_id
JOIN movie_companies AS mc
  ON mc.movie_id = t.id
JOIN name AS n
  ON an.person_id = n.id AND n.gender = 'f'
JOIN role_type AS rt
  ON rt.role = 'actress', title AS t