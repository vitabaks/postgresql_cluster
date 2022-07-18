# Высокодоступный геораспределённый кластер PostgreSQL на базе Patroni с DNS точкой клиентского доступа

[![GitHub license](https://img.shields.io/github/license/IlgizMamyshev/pgsql_cluster)](https://github.com/IlgizMamyshev/pgsql_cluster/blob/master/LICENSE) 
![GitHub stars](https://img.shields.io/github/stars/IlgizMamyshev/pgsql_cluster)

---
![Banner](https://github.com/IlgizMamyshev/pgsql_cluster/blob/master/doc/PostreSQLBanner1600x400.png)

### Развертывание кластера высокой доступности PostgreSQL, готового к производственной среде (на основе "Patroni" и "DCS (etcd)"). Автоматизация с помощью Ansible.

Этот Ansible playbook разработан для развёртывания высокодоступного кластера PostgreSQL на выделенных физических серверах для производственной среды.  
Развёртывание может быть выполнено в виртуальной среде для тестовой среды или небольших проектов.  

В дополнение к развертыванию новых кластеров этот playbook также поддерживает развертывание кластера поверх уже существующего и работающего PostgreSQL. Вы можете преобразовать выделенный экземпляр PostgreSQL в кластер высокой доступности (укажите переменную `postgresql_exists='true'` в файле инвентаризации).  
  
**Внимание!** Ваш экземпляр PostgreSQL будет остановлен перед запуском в составе кластера (запланируйте небольшой простой баз данных).

> :heavy_exclamation_mark: Пожалуйста, проведите тестирование, прежде чем использовать в производственной среде.
  
  
#### Основные возможности:
- развёртывание кластера etcd;
- поддержка аутентификации доступа к etcd;
- развёртывание кластера Patroni с СУБД PostgreSQL или PostgresPro;
- настройка watchdog для Patroni (защита от split-brain);
- поддержка геораспределенного кластера с DNS точкой подключения клиентов (DNS Connection Point);
- поддержка аутентификации доступа к DNS Server;
- развёртывание HAProxy для балансировки доступа к репликам только для чтения;
- настройка брандмауэра;
- настройка параметров ядра ОС Linux;
- поддержка ОС Debian, Astra Linux;
  
  
![PGSQLCluster](https://github.com/IlgizMamyshev/pgsql_cluster/blob/master/doc/PGSQLCluster.png)
  
Данное Решение обеспечивает возможность распределения нагрузки по чтению. Это также позволяет масштабировать кластер с репликами только для чтения.

- порт 5000 (чтение / запись) мастер
- порт 5001 (только чтение) все реплики

###### если переменная "synchronous_mode" равна 'true' (vars/main.yml):

- порт 5002 (только чтение) только синхронные реплики
- порт 5003 (только чтение) только асинхронные реплики

> Для развёртывания кластера без HAProxy задайте `with_haproxy_load_balancing: false` в файле переменных vars/main.yml

#### Компоненты высокой доступности:
[**Patroni**](https://github.com/zalando/patroni) - это шаблон для создания решения высокой доступности с использованием Python и распределенного хранилища конфигурации, такого как ZooKeeper, etcd, Consul или Kubernetes. Используется для автоматизации управления экземплярами PostgreSQL и автоматического аварийного переключения.

[**etcd**](https://github.com/etcd-io/etcd) - это распределенное надежное хранилище ключей и значений для наиболее важных данных распределенной системы. etcd написан на Go и использует алгоритм консенсуса [Raft](https://raft.github.io/) для управления высокодоступным реплицированным журналом. Он используется Patroni для хранения информации о состоянии кластера и параметрах конфигурации PostgreSQL.

[Что такое Распределенный Консенсус (Distributed Consensus)?](http://thesecretlivesofdata.com/raft/)

[**DNS Connection Point for Patroni**](https://github.com/IlgizMamyshev/dnscp) используется для обеспечения единой точки входа. DNSCP обеспечивает регистрацию DNS-записи как единой точки входа для клиентов и позволяет использовать один или более виртуальных IP-адресов (VIP), принадлежащих одной или нескольким подсетям. DNSCP использует функцию обратных вызовов ([callback](https://patroni.readthedocs.io/en/latest/SETTINGS.html)) [Patroni](https://github.com/zalando/patroni). 

#### Компоненты балансировки нагрузки:
[**HAProxy**](http://www.haproxy.org/) — очень быстрое и надежное решение, предлагающее высокую доступность, балансировку нагрузки и прокси для приложений на основе TCP и HTTP. Репозиторий - компонент HAProxy входит в состав репозиторя ОС Astra Linux, но также можно использовать внешний источник.

[**confd**](https://github.com/kelseyhightower/confd) позволяет управлять файлами конфигурации локального приложения используя шаблоны и данные из etcd или Consul. Используется для автоматизации управления файлами конфигурации HAProxy.

#### СУБД PostgreSQL:
[**PostgreSQL**](https://www.postgresql.org) - реляционная база данных с открытым исходным кодом. При использовании ОС Astra Linux возможно использование PostgreSQL в составе репозитория ОС.  
Поддерживаются все поддерживаемые версии PostgreSQL.

:white_check_mark: протестировано: `PostgreSQL 11, 14`

[**Postgres Pro**](https://www.postgrespro.ru) - Российская система управления базами данных на основе PostgreSQL. Коммерческий продукт.
Поддерживаются все версии Postgres Pro, редакции Standard и Enterprise.

:white_check_mark: протестировано: `Postgres Pro 14`

#### Операционные Системы:
- **Debian**: 9, 10, 11
- **Astra Linux**: CE (основан на Debian 9), SE (основан на Debian 10)
:white_check_mark: протестировано: `Astra Linux CE 2.12, Astra Linux SE 1.7`

#### Ansible:
Для автоматизации развёртывания Решения используется [Ansible](https://www.ansible.com) - система управления конфигурациями. При использовании ОС Astra Linux возможно использование Ansible из состава репозитория операционной ситсемы.
Минимальная поддерживаемая версия Ansible - 2.7.

## Требования
Этот playbook требует root привилегий или sudo.

Ansible ([Что такое Ansible](https://www.ansible.com/resources/videos/quick-start-video)?)

## Требования к портам
Список необходимых портов TCP, которые должны быть открыты для кластера баз данных:

- `5432` (PostgreSQL)
- `8008` (Patroni Rest API)
- `2379`, `2380` (etcd)
- `5000` (HAProxy - (чтение / запись) мастер реплика
- `5001` (HAProxy - (только чтение) все реплики
- `5002` (HAProxy - (только чтение) только синхронные реплики
- `5003` (HAProxy - (только чтение) только асинхронные реплики

## Рекомендации
- **Linux (Операционная Система)**: 

Обновите все операционные системы перед развёртыванием;

Присоедините серверы-узлы кластера СУБД к домену [Microsoft Active Directory](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview) или [Astra Linux Directory](https://wiki.astralinux.ru/display/doc/Astra+Linux+Directory). Присоединение к домену является требованием, если вы хотите использовать аутентифицированный доступ к DNS-серверу.

- **DCS (Распределённое Хранилище Конфигурации (Distributed Configuration Store))**: 

Быстрые диски и надежная сеть являются наиболее важными факторами производительности и стабильности кластера etcd.

Избегайте хранения данных etcd на одном диске вместе с другими процессами (такими как база данных), интенсивно использующими ресурсы дисковой подсистемы!  
Храните данные etcd и PostgreSQL на **разных** дисках (см. переменную `etcd_data_dir`), по возможности используйте диски ssd.  
Рекомендуется изучить руководства [по выбору оборудования](https://etcd.io/docs/v3.3.12/op-guide/hardware/) и [настройке](https://etcd.io/docs/v3.3.12/tuning/) etcd.

Для высоконагруженных СУБД рассмотрите установку кластера etcd на выделенных серверах.  

Изучите вопросы планирования кластера etcd. [Примеры](https://www.cybertec-postgresql.com/en/introduction-and-how-to-etcd-clusters-for-patroni/).

- **Как предотвратить потерю данных в случае автоматической отработки отказа (synchronous_modes and pg_rewind)**:

По соображениям надёжности синхронная репликация в данном шаблоне включена. Автоматическая отработка отказа выполняется с переходом только на синхронную реплику.

Чтобы ещё более ужесточить требования к надёжности и свести к минимуму риск потери данных при автоматическом переходе на другой ресурс, вы можете настроить параметры следующим образом:
- synchronous_mode: 'true' (включен по умолчанию в данном playbook)
- synchronous_mode_strict: 'true' (выключен  по умолчанию)
- synchronous_commit: 'on' (или 'remote_apply') ('on'  по умолчанию)
- use_pg_rewind: 'false' (включен по умолчанию)

---

## Развёртывание: быстрый старт
0. [Установите Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) на сервер управления, свой компьютер или ноутбук
##### Пример 1 (установка, используя репозиторий [Astra Linux](https://wiki.astralinux.ru/pages/viewpage.action?pageId=27362819)):
`sudo apt update` \
`sudo apt install ansible`

##### Пример 2 (установка, используя [pip](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-with-pip) ):
`sudo apt update && sudo apt install python3-pip sshpass git -y` \
`sudo pip3 install ansible`

1. Скачайте или клонируйте этот репозиторий

`git clone https://github.com/IlgizMamyshev/pgsql_cluster.git`

2. Перейдите в каталог с файлами playbook

`cd pgsql_cluster/`

3. Отредактируйте файл инвентаризации

##### Задайте IP-адреса и параметры подключения (`ansible_user`, `ansible_ssh_pass` ...)

`vim inventory`

4. Отредактируйте значения переменных в файле vars/[main.yml](./vars/main.yml)

`vim vars/main.yml`

##### Минимальный набор переменных: 
- `proxy_env` # если требуется (*для доступа к репозиториям в сети*)

например:
```
proxy_env:
  http_proxy: http://proxy_server_ip:port
  https_proxy: http://proxy_server_ip:port
```
- `cluster_vip` # один и несколько (для геораспределенного кластера) VIP для клиентского доступа
- `cluster_vcompname`
- `cluster_dnszonefqdn`
- `patroni_cluster_name`
- `with_haproxy_load_balancing`
- `postgresql_version`
- `postgresql_data_dir`

5. Проверьте доступность узлов

`ansible all -m ping`

6. Запустите playbook:

`ansible-playbook deploy_pgcluster.yml -K`

---

## Переменные
Смотри файлы vars/[main.yml](./vars/main.yml), [system.yml](./vars/system.yml) и [Debian.yml](./vars/Debian.yml), чтобы узнать подробности.


## Масштабирование кластера

В разработке..

##### Подготовка:

В разработке..

##### Шаги по добавлению нового узла СУБД:

В разработке..

##### Шаги по добавлению нового узла балансировщика:

В разработке..

## Восстановление и Клонирование
В разработке..

## Обслуживание
Данный вопрос выходит за рамки данного описания.  

Предлагается изучить следующие дополнительные материалы:

- [Учебник: Управление высокодоступными кластерами PostgreSQL с Patroni](https://pgconf.ru/en/2018/108567)
- [Документация Patroni](https://patroni.readthedocs.io/en/latest/)
- [Руководство по эксплуатации etcd](https://etcd.io/docs/v3.3.12/op-guide/)

## Аварийное восстановление

Кластер высокой доступности обеспечивает механизм автоматического перехода на другой ресурс и не охватывает все сценарии аварийного восстановления.
Вы должны позаботиться о резервном копировании своих данных самостоятельно.
##### etcd
> Узлы Patroni сбрасывают состояние параметров DCS на диск при каждом изменении конфигурации в файл patroni.dynamic.json, расположенный в каталоге данных PostgreSQL. Мастеру (узел Patroni с ролью Лидера) разрешено восстанавливать эти параметры из дампа на диске, если они полностью отсутствуют в DCS или если они недействительны.

Тем не менее, рекомендуется ознакомиться с руководством по аварийному восстановлению кластера etcd:
- [Аварийное восстановление etcd](https://etcd.io/docs/v3.3.12/op-guide/recovery)

##### PostgreSQL (базы данных)
Рекомендуемые средства резервного копирования и восстановления:
* [pg_probackup](https://github.com/postgrespro/pg_probackup)

Не забывайте тестировать свои резервные копии.

## Как начать развёртывание с начала
Если вам нужно начать с самого начала, используйте для очистки следующие команды:
- на всех узлах СУБД остановить сервис Patroni и удалить каталог с базами данных (кластер баз данных, PGDATA):
    ```shell
    sudo systemctl stop patroni
    sudo rm -rf /var/lib/postgresql/ # be careful with this if there are other PG clusters
    ```
- затем удалите запись в etcd (можно запустить на любом узле etcd):
    ```shell 
    etcdctl --username patroni-etcd:P@ssw0rd rm --dir --recursive /service/pgsql-cluster/ # настроить, если вы изменили имя кластера, имя пользователя и пароль.
    ```

---

## Лицензия
Под лицензией MIT License. Подробнее см. в файле [LICENSE](./LICENSE) .

## Автор
Илгиз Мамышев (Microsoft SQL Server, PostgreSQL DBA) \
[https://imamyshev.wordpress.com](https://imamyshev.wordpress.com/2022/05/29/dns-connection-point-for-patroni/)

## Обратная связь, отчеты об ошибках, запросы и т.п.
[Добро пожаловать](https://github.com/IlgizMamyshev/pgsql_cluster/issues)!
