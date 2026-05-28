#!/bin/bash

for ((i = 1; i < 6; i++)); do
  log_records=$((RANDOM % 901 + 100))
  for ((j = 0; j < log_records; j++)); do
    ip="$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))"
    response=$(printf '%s\n' 200 201 400 401 403 404 500 501 502 503 | shuf -n 1)
    method=$(printf '%s\n' "GET" "POST" "PUT" "PATCH" "DELETE" | shuf -n 1)
    data=$(date +'%d/%b/%Y:%H:%M:%S %z')
    url=$(printf '%s\n' "/" "/home" "/about" "/contact" "/products" "/services" "/blog" "/admin" "/login" "/api" | shuf -n 1)
    agents=$(printf '%s\n' \
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" \
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:89.0) Gecko/20100101 Firefox/89.0" \
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" \
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Safari/605.1.15" \
      "Mozilla/5.0 (Windows NT 10.0; Trident/7.0; rv:11.0) like Gecko" \
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36 Edg/91.0.864.59" \
      "Googlebot/2.1 (+http://www.google.com/bot.html)" "curl/7.64.1" | shuf -n 1)
    absoluturl="https://example.com$url"
    size=$((RANDOM % 4901 + 100))
    log="$ip - - [$data] \"$method $url HTTP/1.1\" $response $size \"$absoluturl\" \"$agents\""
    echo "$log" >> "$i.log"
  done
  sort -k 4,5 "$i.log" -o "$i.log"
done


# log_record - генерит случайное число записей в лог от 100 до 1000
# ip - адрес с которого отправляли запрос на сервер 
# response - Функция для генерации случайного кода ответа
# Коды ответа HTTP:
# 200 - OK (успешный запрос)
# 201 - Created (ресурс создан)
# 400 - Bad Request (неверный запрос)
# 401 - Unauthorized (требуется аутентификация)
# 403 - Forbidden (доступ запрещен)
# 404 - Not Found (ресурс не найден)
# 500 - Internal Server Error (внутренняя ошибка сервера)
# 501 - Not Implemented (метод не поддерживается)
# 502 - Bad Gateway (ошибка шлюза)
# 503 - Service Unavailable (сервис недоступен)
# method - Методы HTTP:
# GET — запрос на получение ресурса
# POST — запрос на отправку данных
# PUT — запрос на обновление ресурса
# PATCH — запрос на частичное обновление ресурса
# DELETE — запрос на удаление ресурса
# data - дата и время создания запроса на сервер в формате широко применяемом в протоколировании HTTP-запросов
# url - пример запросов на страницы сайтов для логов
# agents - распространеные браузеры для тестирования веб-серверов имитируя разнообразие
# Chrome 91 (Windows 10, 64-bit)
# Firefox 89 (Windows 10, 64-bit)
# Chrome 91 (macOS Big Sur)
# Safari 14.1.1 (macOS Big Sur)
# Internet Explorer 11 (Windows 10)
# Edge 91 (Windows 10, основан на Chromium)
# Googlebot (поисковый робот Google)
# cURL (утилита для передачи данных по сети)
# absoluturl - адрес для каждого запроса, где можно укажать полный адрес
# log - формирование записи лога и запись в файл лога

