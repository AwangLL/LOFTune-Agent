SELECT
  MIN(t.title) AS typical_european_movie
FROM company_type AS ct
JOIN info_type AS it
  ON it.id = mi.info_type_id
JOIN movie_companies AS mc
  ON ct.id = mc.company_type_id
  AND mc.movie_id = mi.movie_id
  AND mc.movie_id = t.id
  AND mc.note LIKE '%(France)%'
  AND mc.note LIKE '%(theatrical)%'
JOIN movie_info AS mi
  ON mi.info IN ('Denish', 'Denmark', 'German', 'Germany', 'Norway', 'Norwegian', 'Sweden', 'Swedish')
  AND mi.movie_id = t.id
JOIN title AS t
  ON t.production_year > 2005
WHERE
  ct.kind = 'production companies'