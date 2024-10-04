SELECT
  MIN(n.name) AS voicing_actress,
  MIN(t.title) AS voiced_movie
FROM aka_name AS an
JOIN char_name AS chn
  ON chn.id = ci.person_role_id
JOIN cast_info AS ci
  ON an.person_id = ci.person_id
  AND ci.movie_id = mc.movie_id
  AND ci.movie_id = mi.movie_id
  AND ci.movie_id = t.id
  AND ci.note IN ('(voice)', '(voice) (uncredited)', '(voice: English version)', '(voice: Japanese version)')
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
JOIN company_name AS cn
  ON cn.country_code = '[us]' AND cn.id = mc.company_id
JOIN info_type AS it
  ON it.id = mi.info_type_id AND it.info = 'release dates'
JOIN movie_companies AS mc
  ON NOT mc.note IS NULL
  AND mc.movie_id = mi.movie_id
  AND mc.movie_id = t.id
  AND (
    mc.note LIKE '%(USA)%' OR mc.note LIKE '%(worldwide)%'
  )
JOIN movie_info AS mi
  ON NOT mi.info IS NULL
  AND (
    mi.info LIKE 'Japan:%200%' OR mi.info LIKE 'USA:%200%'
  )
  AND mi.movie_id = t.id
JOIN name AS n
  ON an.person_id = n.id AND n.gender = 'f' AND n.name LIKE '%Ang%'
JOIN role_type AS rt
  ON rt.role = 'actress'
JOIN title AS t
  ON t.production_year <= 2009 AND t.production_year >= 2005