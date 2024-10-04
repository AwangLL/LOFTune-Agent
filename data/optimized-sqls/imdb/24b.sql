SELECT
  MIN(chn.name) AS voiced_char_name,
  MIN(n.name) AS voicing_actress_name,
  MIN(t.title) AS kung_fu_panda
FROM aka_name AS an
JOIN char_name AS chn
  ON chn.id = ci.person_role_id
JOIN cast_info AS ci
  ON an.person_id = ci.person_id
  AND ci.movie_id = mc.movie_id
  AND ci.movie_id = mi.movie_id
  AND ci.movie_id = mk.movie_id
  AND ci.movie_id = t.id
  AND ci.note IN ('(voice)', '(voice) (uncredited)', '(voice: English version)', '(voice: Japanese version)')
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
JOIN company_name AS cn
  ON cn.country_code = '[us]' AND cn.id = mc.company_id AND cn.name = 'DreamWorks Animation'
JOIN info_type AS it
  ON it.id = mi.info_type_id AND it.info = 'release dates'
JOIN keyword AS k
  ON k.id = mk.keyword_id
  AND k.keyword IN ('computer-animated-movie', 'hand-to-hand-combat', 'hero', 'martial-arts')
JOIN movie_companies AS mc
  ON mc.movie_id = mi.movie_id AND mc.movie_id = mk.movie_id AND mc.movie_id = t.id
JOIN movie_info AS mi
  ON NOT mi.info IS NULL
  AND (
    mi.info LIKE 'Japan:%201%' OR mi.info LIKE 'USA:%201%'
  )
  AND mi.movie_id = mk.movie_id
  AND mi.movie_id = t.id
JOIN movie_keyword AS mk
  ON mk.movie_id = t.id
JOIN name AS n
  ON an.person_id = n.id AND n.gender = 'f' AND n.name LIKE '%An%'
JOIN role_type AS rt
  ON rt.role = 'actress'
JOIN title AS t
  ON t.production_year > 2010 AND t.title LIKE 'Kung Fu Panda%'