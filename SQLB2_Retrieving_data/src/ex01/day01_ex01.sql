-- Этот запрос работает только с нашими таблицами
-- потому что имена с заглавной буквы, а названия пицц с маленькой
-- сортировка сначала заглавных, потом строчных

SELECT name AS object_name FROM person
UNION ALL
SELECT pizza_name FROM menu
ORDER BY object_name; 

-- Этот запрос универсальный

SELECT object_name 
FROM (
    SELECT 1 AS sort, name AS object_name FROM person
    UNION ALL
    SELECT 2, pizza_name FROM menu
) AS temp
ORDER BY sort, object_name;