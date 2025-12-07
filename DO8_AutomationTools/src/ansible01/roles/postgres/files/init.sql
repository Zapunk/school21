CREATE TABLE IF NOT EXISTS spectrav (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category TEXT NOT NULL,
    value TEXT NOT NULL,
    UNIQUE (category, value)
);

INSERT INTO spectrav (category, value)
SELECT 'Дни недели', v
FROM (VALUES
    ('Понедельник'),
    ('Вторник'),
    ('Среда'),
    ('Четверг'),
    ('Пятница'),
    ('Суббота'),
    ('Воскресенье')
) AS t(v)
WHERE NOT EXISTS (
    SELECT 1 FROM spectrav WHERE category = 'Дни недели' AND value = t.v
);

INSERT INTO spectrav (category, value)
SELECT 'Времена года', v
FROM (VALUES
    ('Зима'),
    ('Весна'),
    ('Лето'),
    ('Осень')
) AS t(v)
WHERE NOT EXISTS (
    SELECT 1 FROM spectrav WHERE category = 'Времена года' AND value = t.v
);

INSERT INTO spectrav (category, value)
SELECT 'Время суток', v
FROM (VALUES
    ('Утро'),
    ('День'),
    ('Вечер'),
    ('Ночь')
) AS t(v)
WHERE NOT EXISTS (
    SELECT 1 FROM spectrav WHERE category = 'Время суток' AND value = t.v
);