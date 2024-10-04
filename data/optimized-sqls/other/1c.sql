SELECT
  MIN(mc.note) AS production_note,
  MIN(t.title) AS movie_title,
  MIN(t.production_year) AS movie_year
FROM company_type AS ct
JOIN info_type AS it
  ON it.id = mi_idx.info_type_id AND it.info = 'top 250 rank'
JOIN movie_companies AS mc
  ON NOT mc.note LIKE '%(as Metro-Goldwyn-Mayer Pictures)%'
  AND ct.id = mc.company_type_id
  AND mc.movie_id = mi_idx.movie_id
  AND mc.movie_id = t.id
  AND mc.note LIKE '%(co-production)%'
JOIN movie_info_idx AS mi_idx
  ON mi_idx.movie_id = t.id
JOIN title AS t
  ON t.production_year > 2010
WHERE
  ct.kind = 'production companies'