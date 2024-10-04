SELECT
  MIN(an.name) AS acress_pseudonym,
  MIN(t.title) AS japanese_anime_movie
FROM aka_name AS an
JOIN cast_info AS ci
  ON an.person_id = ci.person_id
  AND ci.movie_id = mc.movie_id
  AND ci.movie_id = t.id
  AND ci.note = '(voice: English version)'
  AND ci.person_id = n.id
  AND ci.role_id = rt.id
JOIN company_name AS cn
  ON cn.country_code = '[jp]' AND cn.id = mc.company_id
JOIN movie_companies AS mc
  ON NOT mc.note LIKE '%(USA)%'
  AND mc.movie_id = t.id
  AND (
    mc.note LIKE '%(2006)%' OR mc.note LIKE '%(2007)%'
  )
  AND mc.note LIKE '%(Japan)%'
JOIN name AS n
  ON NOT n.name LIKE '%Yu%' AND an.person_id = n.id AND n.name LIKE '%Yo%'
JOIN role_type AS rt
  ON rt.role = 'actress'
JOIN title AS t
  ON t.production_year <= 2007
  AND t.production_year >= 2006
  AND (
    t.title LIKE 'Dragon Ball Z%' OR t.title LIKE 'One Piece%'
  )