SELECT action_date,
    (SELECT name FROM person WHERE id = tmp.person_id) AS person_name
FROM (
    SELECT order_date AS action_date, person_id FROM person_order
    INTERSECT
    SELECT visit_date, person_id FROM person_visits
) AS tmp
ORDER BY action_date ASC, person_name DESC;