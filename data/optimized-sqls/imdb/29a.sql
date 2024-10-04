SELECT
  MIN(chn.name) AS voiced_char,
  MIN(n.name) AS voicing_actress,
  MIN(t.title) AS voiced_animation
FROM aka_name AS an
JOIN complete_cast AS cc
  ON cc.movie_id = ci.movie_id
  AND cc.movie_id = mc.movie_id
  AND cc.movie_id = mi.movie_id
  AND cc.movie_id = mk.movie_id
  AND cc.movie_id = t.id
  AND cc.status_id = cct2.id
  AND cc.subject_id = cct1.id
JOIN comp_cast_type AS cct1
  ON cct1.kind = 'cast'
JOIN comp_cast_type AS cct2
  ON cct2.kind = 'complete+verified'
JOIN char_name AS chn
  ON chn.id = ci.person_role_id AND chn.name = 'Queen'
JOIN cast_info AS ci
  ON an.person_id = ci.person_id
  AND ci.movie_id = mc.movie_id
  AND ci.movie_id = mi.movie_id
  AND ci.movie_id = mk.movie_id
  AND ci.movie_id = t.id
  AND ci.note IN ('(voice)', '(voice) (uncredited)', '(voice: English version)')
  AND ci.person_id = n.id
  AND ci.person_id = pi.person_id
  AND ci.role_id = rt.id
JOIN company_name AS cn
  ON cn.country_code = '[us]' AND cn.id = mc.company_id
JOIN info_type AS it
  ON it.id = mi.info_type_id AND it.info = 'release dates'
JOIN info_type AS it3
  ON it3.id = pi.info_type_id AND it3.info = 'trivia'
JOIN keyword AS k
  ON k.id = mk.keyword_id AND k.keyword = 'computer-animation'
JOIN movie_companies AS mc
  ON mc.movie_id = mi.movie_id AND mc.movie_id = mk.movie_id AND mc.movie_id = t.id
JOIN movie_info AS mi
  ON NOT mi.info IS NULL
  AND (
    mi.info LIKE 'Japan:%200%' OR mi.info LIKE 'USA:%200%'
  )
  AND mi.movie_id = mk.movie_id
  AND mi.movie_id = t.id
JOIN movie_keyword AS mk
  ON mk.movie_id = t.id
JOIN name AS n
  ON an.person_id = n.id AND n.gender = 'f' AND n.id = pi.person_id AND n.name LIKE '%An%', person_info AS pi
JOIN role_type AS rt
  ON rt.role = 'actress'
JOIN title AS t
  ON t.production_year <= 2010 AND t.production_year >= 2000 AND t.title = 'Shrek 2'