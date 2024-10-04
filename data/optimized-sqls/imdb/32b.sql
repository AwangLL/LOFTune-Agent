SELECT
  MIN(lt.link) AS link_type,
  MIN(t1.title) AS first_movie,
  MIN(t2.title) AS second_movie
FROM keyword AS k
CROSS JOIN title AS t2
JOIN movie_keyword AS mk
  ON k.id = mk.keyword_id
JOIN movie_link AS ml
  ON ml.linked_movie_id = t2.id
JOIN link_type AS lt
  ON lt.id = ml.link_type_id
JOIN title AS t1
  ON mk.movie_id = t1.id AND ml.movie_id = t1.id
WHERE
  k.keyword = 'character-name-in-title'