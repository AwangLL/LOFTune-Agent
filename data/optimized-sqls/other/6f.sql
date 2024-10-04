SELECT
  MIN(k.keyword) AS movie_keyword,
  MIN(n.name) AS actor_name,
  MIN(t.title) AS hero_movie
FROM cast_info AS ci
JOIN name AS n
  ON ci.person_id = n.id
JOIN title AS t
  ON ci.movie_id = t.id AND t.production_year > 2000
JOIN movie_keyword AS mk
  ON ci.movie_id = mk.movie_id AND mk.movie_id = t.id
JOIN keyword AS k
  ON k.id = mk.keyword_id
  AND k.keyword IN ('based-on-comic', 'fight', 'marvel-comics', 'second-part', 'sequel', 'superhero', 'tv-special', 'violence')