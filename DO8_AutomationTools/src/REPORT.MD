## Part 1. Удаленное конфигурирование узла через Ansible.

### Создать с помощью Vagrant три машины: manager, node01, node02. Не устанавливать с помощью shell-скриптов docker при создании машин на Vagrant! Прокинуть порты node01 на локальную машину для доступа к пока еще не развернутому микросервисному приложению

  ```shell
  Vagrant.configure("2") do |config|
    config.ssh.forward_agent = true
    config.vm.box = "bento/ubuntu-22.04"
    config.vm.synced_folder ".", "/vagrant"

    config.vm.define "manager" do |manager|
         manager.vm.hostname = "manager"
        manager.vm.network "private_network", ip: "192.168.56.10"
    
        manager.vm.provider "virtualbox" do |vb|
            vb.memory = 4096
            vb.cpus = 4
            vb.name = "manager"
        end    
    end

    config.vm.define "node01" do |node|
        node.vm.hostname = "node01"
        node.vm.network "private_network", ip: "192.168.56.11"

        [8081,8082,8083,8084,8085,8086,8087].each do |port|
            node.vm.network "forwarded_port", guest: port, host: port
        end
        # node.vm.network "forwarded_port", guest: 5432, host: 5432
        # node.vm.network "forwarded_port", guest: 5672, host: 5672
        # node.vm.network "forwarded_port", guest: 15672, host: 15672
        
        node.vm.provider "virtualbox" do |vb|
            vb.memory = 2048
            vb.cpus = 2
            vb.name = "node01"
        end
    end

    config.vm.define "node02" do |node|
        node.vm.hostname = "node02"
        node.vm.network "private_network", ip: "192.168.56.12"
        node.vm.provider "virtualbox" do |vb|
            vb.memory = 2048
            vb.cpus = 2
            vb.name = "node02"
        end    
    end
end
  ```

### Подготовить manager как рабочую станцию для удаленного конфигурирования (помощь по Ansible в материалах)

- Зайти на manager.

    ![1](img/1.png)

- На manager проверить подключение к node01 через ssh по приватной сети.
- Сгенерировать ssh-ключ для подключения к node01 из manager (без passphrase).

    ![2](img/2.png)

- Скопировать на manager docker-compose файл и исходный код микросервисов. (Используй проект из папки src и docker-compose файл из предыдущей главы)

  - В Vagrant у меня уже есть общая папка, поэтому проект уже доступен из ВМ. Но для облекчения процесса скопирую проект из общей папки в рабочую папку ВМ с помощью скрипта.

    ```shell
    mkdir -p /home/vagrant/project
    cp -r /vagrant/services /home/vagrant/project/
    ```

- Установить Ansible на менеджер и создать папку ansible, в которой создать inventory-файл. 

    ![3](img/3.png)

    мой inventory.ini - файл

    ```shell
    [manager]
    127.0.0.1 ansible_connection=local

    [node01]
    192.168.56.11 ansible_user=vagrant
    ```

- Использовать модуль ping для проверки подключения через Ansible.

    ![4](img/4.png)

### Написать первый плейбук для Ansible, который выполняет apt update, устанавливает docker, docker-compose, копирует compose-файл из manager'а и разворачивает микросервисное приложение

```shell
- hosts: node01,node02
  become: true
  tasks:
    - name: Скопировать скрипт установки Docker
      copy:
        src: files/install_docker.sh
        dest: /tmp/install_docker.sh
        mode: '0755'

    - name: Установить Docker
      shell: /tmp/install_docker.sh
      args:
        creates: /usr/bin/docker

    - name: Создать каталог
      file:
        path: /project/services/ansible/files
        state: directory
        mode: '0755'

    - name: Скопировать docker-compose.yml на ноды
      copy:
        src: files/docker-compose.yml
        dest: /project/services/ansible/files/docker-compose.yml
        mode: '0644'

    - name: Скопировать папку database (init.sql)
      copy:
        src: ../database/
        dest: /project/services/database/
        mode: '0644'

    - name: Deploy
      shell: docker compose -f /project/services/ansible/files/docker-compose.yml up -d
      args:
        chdir: /project/services/ansible/files

    - name: Статус контейнеров
      shell: docker ps
      register: docker_ps
      changed_when: false

    - name: Вывести статус контейнеров
      debug:
        var: docker_ps.stdout_lines
```

Данный playbook копирует готовый скрипт по установке Docker(из предыдущей главы) и в скрипте уже есть инструкция `apt update` поэтому обновление всех пакетов произойдет на всех нодах.

Видим что все заработало

![5](img/5.png)

### Прогнать заготовленные тесты через postman и удостовериться, что все они проходят успешно

![6](img/6.png)

### Сформировать три роли:

- роль application выполняет развертывание микросервисного приложения при помощи docker-compose;

```shell
- name: Скопировать скрипт установки Docker
  copy:
    src: "{{ playbook_dir }}/files/install_docker.sh"
    dest: /tmp/install_docker.sh
    mode: '0755'

- name: Установить Docker
  shell: /tmp/install_docker.sh
  args:
    creates: /usr/bin/docker

- name: Создать каталог проекта
  file:
    path: /project/services/ansible/files
    state: directory
    mode: '0755'

- name: Создать директорию для базы данных
  file:
    path: /project/services/database
    state: directory
    mode: '0755'

- name: Скопировать docker-compose.yml
  copy:
    src: "{{ playbook_dir }}/files/docker-compose.yml"
    dest: /project/services/ansible/files/docker-compose.yml
    mode: '0644'

- name: Скопировать init.sql
  copy:
    src: "{{ playbook_dir }}/../database/init.sql"
    dest: /project/services/database/init.sql
    mode: '0644'

- name: Deploy
  community.docker.docker_compose:
    project_src: /project/services/ansible/files
    state: present

- name: Статус контейнеров
  shell: docker ps
  register: docker_ps

- name: Вывести статус контейнеров
  debug:
    var: docker_ps.stdout_lines
```

- apache устанавливает и запускает стандартный apache сервер;

```shell
- name: Установить Apache
  apt:
    name: apache2
    state: present
    update_cache: yes

- name: Запустить Apache
  service:
    name: apache2
    state: started
    enabled: yes

- name: Создать тестовую страницу
  copy:
    content: "YUHHU!!! Apache already work!"
    dest: /var/www/html/index.html
```

- postgres устанавливает и запускает postgres, создает базу данных с произвольной таблицей и добавляет в нее три произвольные записи.

```shell
- name: Установить PostgreSQL
  apt:
    name:
      - postgresql
      - python3-psycopg2
    state: present
    update_cache: yes

- name: Запустить PostgreSQL
  service:
    name: postgresql
    state: started
    enabled: yes

- name: Копировать SQL-скрипт
  copy:
    src: init.sql
    dest: /tmp/init.sql
    mode: '0644'

- name: Создать базу данных db_01
  shell: |
    sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='db_01'" | grep -q 1 || \
    sudo -u postgres psql -c "CREATE DATABASE db_01"
  args:
    executable: /bin/bash

- name: Создать таблицу и вставить данные
  shell: sudo -u postgres psql -d db_01 -f /tmp/init.sql
  args:
    chdir: /tmp
```

Таблица с тремя записями:

```sql
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
```

- Назначить первую роль node01 и вторые две роли node02, проверить postman-тестами работоспособность микросервисного приложения, удостовериться в доступности postgres и apache-сервера. Для Apache веб-страница должна открыться в браузере. Что касается PostgreSQL, необходимо подключиться с локальной машины и отобразить содержимое ранее созданной таблицы с данными.

Назначение ролей в плейбуке:

```shell
- hosts: node01
  become: true
  roles:
    - application

- hosts: node02
  become: true
  roles:
    - apache
    - postgres
```

Прогоняем тесты в `Postman`

![7](img/7.png)

Проверяем доступность Apache

![8](img/8.png)

Проверяем PostgreSQL

![9](img/9.png)
