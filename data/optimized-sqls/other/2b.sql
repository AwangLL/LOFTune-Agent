SELECT
  MIN(t.title) AS movie_title
FROM company_name AS cn
JOIN keyword AS k
  ON k.id = mk.keyword_id AND k.keyword = 'character-name-in-title'
JOIN movie_companies AS mc
  ON cn.id = mc.company_id AND mc.movie_id = mk.movie_id AND mc.movie_id = t.id
JOIN movie_keyword AS mk
  ON mk.movie_id = t.id, title AS t
WHERE
  cn.country_code = '[nl]'