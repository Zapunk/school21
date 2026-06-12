SELECT order_date, name || ' (age:' || CAST(age AS varchar) || ')' AS person_information
FROM (
    SELECT person_id AS id, order_date FROM person_order
) AS tmp_po
NATURAL JOIN person
ORDER BY order_date ASC, person_information ASC;