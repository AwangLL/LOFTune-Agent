SELECT
  MIN(t.title) AS movie_title
FROM keyword AS k
JOIN movie_keyword AS mk
  ON k.id = mk.keyword_id
JOIN movie_info AS mi
  ON mi.info IN ('American', 'Denish', 'Denmark', 'German', 'Germany', 'Norway', 'Norwegian', 'Sweden', 'Swedish', 'USA')
  AND mi.movie_id = mk.movie_id
JOIN title AS t
  ON mi.movie_id = t.id AND mk.movie_id = t.id AND t.production_year > 1990
WHERE
  k.keyword LIKE '%sequel%'