SELECT
  MIN(t.title) AS american_vhs_movie
FROM company_type AS ct
JOIN info_type AS it
  ON it.id = mi.info_type_id
JOIN movie_companies AS mc
  ON ct.id = mc.company_type_id
  AND mc.movie_id = mi.movie_id
  AND mc.movie_id = t.id
  AND mc.note LIKE '%(1994)%'
  AND mc.note LIKE '%(USA)%'
  AND mc.note LIKE '%(VHS)%'
JOIN movie_info AS mi
  ON mi.info IN ('America', 'USA') AND mi.movie_id = t.id
JOIN title AS t
  ON t.production_year > 2010
WHERE
  ct.kind = 'production companies'