## Готовый докер

  - Выкаченый готовый образ nginx через `docker pull`

    ![Docker_pull](img/docker_pull.png)

  - Hаличие докер-образа через `docker images`

    ![Docker_images](img/docker_images.png)

  - Запуск докер-образа через `docker run -d` и проверка через `docker ps`

    ![Docker_run](img/docker_run_ps.png)

  - Просмотр информации о контейнере через `docker inspect`. Видим размер контейнера, список проброшеных портов и ip контейнера

    ![Docker_inspect](img/docker_inspect.png)

  - Остановка докер контейнер через `docker stop` и проверка через `docker ps`

    ![Docker_stop](img/docker_stop.png)

  - Запуск докера с портами 80 и 443

    ![Docker_ports](img/docker_ports.png)

  - Перезапуск докера через `docker restart`

    ![Docker_restart](img/docker_restart.png)

## Операции с контейнером

  - Чтение конфигурационного файла nginx.conf

    ![Docker_exec](img/docker_exec.png)

  - Создание файла nginx.conf на локальной машине(копирование)

    ![Docker_cp](img/docker_cp.png)

  - Настраиваем блок `server` для страницы статуса

    ![Docker_server](img/docker_server.png)

  - Копируем файл обратно в докер-образ

    ![Docker_cp_in](img/docker_cp_in.png)

  - Перезапуск nginx внутри контейнера

    ![Docker_restart2](img/docker_restart2.png)

  - Проверяем что страничка отдается `localhost:80/status`

    ![Docvker_status](img/docker_status.png)

  - Экспортируем контейнер в файл

    ![Docker_export](img/docker_export.png)

  - Остановка и удаление контейнера, а затем принудительное удаление образа

    ![Docker_del](img/docker_del.png)

  
  - Импорт контейнера обратно и запуск его

    ![Docker_import](img/docker_import.png)

  - Запуск контейнера

    ![Docker_new_run](img/docker_new_run.png)

  - Проверяем статус

    ![Docker_new_status](img/docker_new_status.png)
    