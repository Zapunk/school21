WITH tmp AS (
    SELECT generate_series(CAST('2022-01-01' AS date), CAST('2022-01-10' AS date), CAST('1 day' AS interval)) AS missing_date
)
SELECT CAST(missing_date AS date)
FROM tmp
LEFT JOIN person_visits ON tmp.missing_date = person_visits.visit_date AND (person_visits.person_id = 1 OR person_visits.person_id = 2)
WHERE person_visits.visit_date IS NULL
ORDER BY missing_date ASC;