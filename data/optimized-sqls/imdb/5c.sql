SELECT
  MIN(t.title) AS american_movie
FROM company_type AS ct
JOIN info_type AS it
  ON it.id = mi.info_type_id
JOIN movie_companies AS mc
  ON NOT mc.note LIKE '%(TV)%'
  AND ct.id = mc.company_type_id
  AND mc.movie_id = mi.movie_id
  AND mc.movie_id = t.id
  AND mc.note LIKE '%(USA)%'
JOIN movie_info AS mi
  ON mi.info IN ('American', 'Denish', 'Denmark', 'German', 'Germany', 'Norway', 'Norwegian', 'Sweden', 'Swedish', 'USA')
  AND mi.movie_id = t.id
JOIN title AS t
  ON t.production_year > 1990
WHERE
  ct.kind = 'production companies'