SELECT
  MIN(cn.name) AS producing_company,
  MIN(lt.link) AS link_type,
  MIN(t.title) AS complete_western_sequel
FROM complete_cast AS cc
JOIN comp_cast_type AS cct1
  ON cc.subject_id = cct1.id AND cct1.kind IN ('cast', 'crew')
JOIN comp_cast_type AS cct2
  ON cc.status_id = cct2.id AND cct2.kind = 'complete'
JOIN title AS t
  ON cc.movie_id = t.id AND t.production_year = 1998
JOIN movie_link AS ml
  ON cc.movie_id = ml.movie_id AND ml.movie_id = t.id
JOIN link_type AS lt
  ON lt.id = ml.link_type_id AND lt.link LIKE '%follow%'
JOIN movie_keyword AS mk
  ON cc.movie_id = mk.movie_id AND mk.movie_id = ml.movie_id AND mk.movie_id = t.id
JOIN keyword AS k
  ON k.id = mk.keyword_id AND k.keyword = 'sequel'
JOIN movie_info AS mi
  ON cc.movie_id = mi.movie_id
  AND mi.info IN ('German', 'Germany', 'Sweden', 'Swedish')
  AND mi.movie_id = mk.movie_id
  AND mi.movie_id = ml.movie_id
  AND mi.movie_id = t.id
JOIN movie_companies AS mc
  ON cc.movie_id = mc.movie_id
  AND mc.movie_id = mi.movie_id
  AND mc.movie_id = mk.movie_id
  AND mc.movie_id = ml.movie_id
  AND mc.movie_id = t.id
  AND mc.note IS NULL
JOIN company_name AS cn
  ON cn.country_code <> '[pl]'
  AND cn.id = mc.company_id
  AND (
    cn.name LIKE '%Film%' OR cn.name LIKE '%Warner%'
  )
JOIN company_type AS ct
  ON ct.id = mc.company_type_id AND ct.kind = 'production companies'