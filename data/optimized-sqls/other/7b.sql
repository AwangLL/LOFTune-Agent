SELECT
  MIN(n.name) AS of_person,
  MIN(t.title) AS biography_movie
FROM aka_name AS an
JOIN cast_info AS ci
  ON an.person_id = ci.person_id
  AND ci.movie_id = ml.linked_movie_id
  AND ci.movie_id = t.id
  AND ci.person_id = n.id
  AND ci.person_id = pi.person_id
JOIN info_type AS it
  ON it.id = pi.info_type_id AND it.info = 'mini biography'
JOIN link_type AS lt
  ON lt.id = ml.link_type_id AND lt.link = 'features'
JOIN movie_link AS ml
  ON ml.linked_movie_id = t.id
JOIN name AS n
  ON an.person_id = n.id AND n.gender = 'm' AND n.id = pi.person_id AND n.name_pcode_cf LIKE 'D%'
JOIN person_info AS pi
  ON an.person_id = pi.person_id AND pi.note = 'Volker Boehm'
JOIN title AS t
  ON t.production_year <= 1984 AND t.production_year >= 1980
WHERE
  an.name LIKE '%a%'