SELECT
  MIN(cn.name) AS from_company,
  MIN(mc.note) AS production_note,
  MIN(t.title) AS movie_based_on_book
FROM company_name AS cn
JOIN company_type AS ct
  ON NOT ct.kind IS NULL AND ct.id = mc.company_type_id AND ct.kind <> 'production companies'
JOIN keyword AS k
  ON k.id = mk.keyword_id AND k.keyword IN ('based-on-novel', 'revenge', 'sequel')
JOIN link_type AS lt
  ON lt.id = ml.link_type_id
JOIN movie_companies AS mc
  ON NOT mc.note IS NULL
  AND cn.id = mc.company_id
  AND mc.movie_id = mk.movie_id
  AND mc.movie_id = ml.movie_id
  AND mc.movie_id = t.id
JOIN movie_keyword AS mk
  ON mk.movie_id = ml.movie_id AND mk.movie_id = t.id
JOIN movie_link AS ml
  ON ml.movie_id = t.id
JOIN title AS t
  ON t.production_year > 1950
WHERE
  cn.country_code <> '[pl]'
  AND (
    cn.name LIKE '20th Century Fox%' OR cn.name LIKE 'Twentieth Century Fox%'
  )