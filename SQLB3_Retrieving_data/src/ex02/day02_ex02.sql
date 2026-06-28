SELECT COALESCE(person.name, '-') AS person_name, CAST(tmp.visit_date AS date), COALESCE(pizzeria.name, '-') AS pizzeria_name
FROM (
    SELECT * FROM person_visits
    WHERE visit_date BETWEEN CAST('2022-01-01' AS date) AND CAST('2022-01-03' AS date)

) AS tmp
FULL JOIN person ON person.id = tmp.person_id
FULL JOIN pizzeria ON tmp.pizzeria_id = pizzeria.id
ORDER BY person_name, visit_date, pizzeria_name; 