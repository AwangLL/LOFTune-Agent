SELECT
  MIN(an.name) AS cool_actor_pseudonym,
  MIN(t.title) AS series_named_after_char
FROM aka_name AS an
JOIN cast_info AS ci
  ON an.person_id = ci.person_id
  AND ci.movie_id = mc.movie_id
  AND ci.movie_id = mk.movie_id
  AND ci.movie_id = t.id
  AND ci.person_id = n.id
JOIN company_name AS cn
  ON cn.country_code = '[us]' AND cn.id = mc.company_id
JOIN keyword AS k
  ON k.id = mk.keyword_id AND k.keyword = 'character-name-in-title'
JOIN movie_companies AS mc
  ON mc.movie_id = mk.movie_id AND mc.movie_id = t.id
JOIN movie_keyword AS mk
  ON mk.movie_id = t.id
JOIN name AS n
  ON an.person_id = n.id
JOIN title AS t
  ON t.episode_nr < 100 AND t.episode_nr >= 50