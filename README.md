# Высокодоступный кластер PostgreSQL на базе Patroni. С DNS точкой клиентского доступа, с поддержкой геораспределения.

[![GitHub license](https://img.shields.io/github/license/IlgizMamyshev/pgsql_cluster)](./LICENSE) 
![GitHub stars](https://img.shields.io/github/stars/IlgizMamyshev/pgsql_cluster)

---
![Banner](https://github.com/IlgizMamyshev/pgsql_cluster/blob/master/doc/PostreSQLBanner1600x400.png)

### Развертывание кластера высокой доступности PostgreSQL на основе Patroni. Автоматизация с помощью Ansible.

Этот Ansible playbook разработан для развёртывания высокодоступного кластера PostgreSQL на выделенных физических серверах для производственной среды.  
Развёртывание может быть выполнено в виртуальной среде для тестовой среды или небольших проектов.  

В дополнение к развертыванию новых кластеров этот playbook также поддерживает развертывание кластера поверх уже существующего и работающего PostgreSQL. Вы можете преобразовать выделенный экземпляр PostgreSQL в кластер высокой доступности (укажите переменную `postgresql_exists='true'` в файле инвентаризации).  
  
**Внимание!** Ваш экземпляр PostgreSQL будет остановлен перед запуском в составе кластера (запланируйте небольшой простой баз данных).

> :heavy_exclamation_mark: Пожалуйста, проведите тестирование, прежде чем использовать в производственной среде.
  
  
#### Основные возможности:
- развёртывание кластера [Patroni](https://patroni.readthedocs.io/en/latest/) с СУБД PostgreSQL или PostgresPro;
- использование встроенного механизма распределённого консенсуса или использование внешней DCS (etcd);
- развёртывание кластера [etcd](https://etcd.io/docs/v3.5/op-guide/);
- настройка watchdog для Patroni (защита от split-brain);
- DNS точка подключения клиентов ([DNS Connection Point](https://github.com/IlgizMamyshev/dnscp));
- поддержка геораспределенного кластера ([DNS Connection Point](https://github.com/IlgizMamyshev/dnscp));
- развёртывание HAProxy для балансировки доступа к репликам только для чтения;
- настройка брандмауэра операционной системы;
- настройка параметров ядра операционной системы Linux;
- поддержка операционных систем Debian, Astra Linux;

##### Высокодоступный кластер, на базе Patroni (на чистом RAFT) и DNSCP (балансировка с HAProxy опционально):  
![PGSQLCluster](https://github.com/IlgizMamyshev/pgsql_cluster/blob/master/doc/PGSQLClusterPatroniOnPureRAFT.png)

Другие варианты реализации архитектуры высокой доступности - смотреть [примеры](./doc/README.md).

Применение HAProxy обеспечивает возможность распределения нагрузки по чтению. Это также позволяет масштабировать кластер с репликами только для чтения.

- порт 5000 (чтение / запись) мастер
- порт 5001 (только чтение) все реплики

###### если переменная "synchronous_mode" равна 'true' (vars/main.yml):

- порт 5002 (только чтение) только синхронные реплики
- порт 5003 (только чтение) только асинхронные реплики

> Для развёртывания кластера без HAProxy задайте `with_haproxy_load_balancing: false` в файле переменных vars/main.yml

#### Компоненты высокой доступности:
[**Patroni**](https://github.com/zalando/patroni) - это шаблон для создания решения высокой доступности с использованием Python и распределенного хранилища конфигурации, [*собственного*](https://github.com/zalando/patroni/pull/375) или такого как ZooKeeper, etcd, Consul или Kubernetes. Используется для автоматизации управления экземплярами PostgreSQL и автоматического аварийного переключения.

[**etcd**](https://github.com/etcd-io/etcd) - это распределенное надежное хранилище ключей и значений для наиболее важных данных распределенной системы. etcd написан на Go и использует алгоритм консенсуса [Raft](https://raft.github.io/) для управления высокодоступным реплицированным журналом. Он используется Patroni для хранения информации о состоянии кластера и параметрах конфигурации PostgreSQL.

[Что такое Распределенный Консенсус (Distributed Consensus)?](http://thesecretlivesofdata.com/raft/)

[**DNS Connection Point for Patroni**](https://github.com/IlgizMamyshev/dnscp) используется для обеспечения единой точки входа. DNSCP обеспечивает регистрацию DNS-записи как единой точки входа для клиентов и позволяет использовать один или более виртуальных IP-адресов (VIP), принадлежащих одной или нескольким подсетям. DNSCP использует функцию обратных вызовов ([callback](https://patroni.readthedocs.io/en/latest/SETTINGS.html)) [Patroni](https://github.com/zalando/patroni). 

#### Компоненты балансировки нагрузки:
[**HAProxy**](http://www.haproxy.org/) — очень быстрое и надежное решение, предлагающее высокую доступность, балансировку нагрузки и прокси для приложений на основе TCP и HTTP. HAProxy входит в состав репозиторя ОС Astra Linux, но также можно использовать внешний источник.

[**confd**](https://github.com/kelseyhightower/confd) позволяет управлять файлами конфигурации локального приложения используя шаблоны и данные из etcd. Используется для автоматизации управления файлами конфигурации HAProxy.

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
Для автоматизации развёртывания Решения используется [Ansible](https://www.ansible.com) - система управления конфигурациями. При использовании ОС Astra Linux возможно использование Ansible из состава репозитория операционной системы.
Минимальная поддерживаемая версия Ansible - 2.7.

## Требования
Этот playbook требует root привилегий или sudo.

Ansible ([Что такое Ansible](https://www.ansible.com/resources/videos/quick-start-video)?)

## Требования к портам
Список необходимых портов TCP, которые должны быть открыты для кластера баз данных:

- `5432` (PostgreSQL)
- `8008` (Patroni Rest API)
- `2379` (Patroni RAFT)
- `2379`, `2380` (etcd)
- `5000` (HAProxy - (чтение / запись) мастер реплика
- `5001` (HAProxy - (только чтение) все реплики
- `5002` (HAProxy - (только чтение) только синхронные реплики
- `5003` (HAProxy - (только чтение) только асинхронные реплики

#### Связанные ссылки:
- [Планирование портов и протоколов](/doc/protocol_workloads.md)

## Рекомендации
- **Linux (Операционная Система)**: 

Обновите все операционные системы перед развёртыванием;

Присоедините серверы-узлы кластера СУБД к домену [Microsoft Active Directory](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview) или [Astra Linux Directory](https://wiki.astralinux.ru/display/doc/Astra+Linux+Directory). Присоединение к домену является требованием, если вы хотите использовать аутентифицированный доступ к DNS-серверу.

- **pure RAFT**: 

Patroni может не зависеть от сторонних систем DCS (Distributed Consensus Store, типа etcd, Consul, ZooKeeper) за счёт собственной реализации [RAFT](https://patroni.readthedocs.io/en/latest/SETTINGS.html#raft-settings). При необходимости возможность использовать внешние системы DCS остаётся.

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
- [synchronous_mode](https://patroni.readthedocs.io/en/latest/replication_modes.html#synchronous-mode): 'true' (включен по умолчанию в данном playbook)
- [synchronous_mode_strict](https://patroni.readthedocs.io/en/latest/replication_modes.html#synchronous-mode): 'true' (выключен  по умолчанию)
- [synchronous_commit](https://postgrespro.ru/docs/postgrespro/14/runtime-config-wal#GUC-SYNCHRONOUS-COMMIT): 'on' (или 'remote_apply') ('on'  по умолчанию)
- [use_pg_rewind](https://postgrespro.ru/docs/postgrespro/14/app-pgrewind): '[false](https://patroni.readthedocs.io/en/latest/SETTINGS.html#dynamic-configuration-settings)' (включен по умолчанию)

---

## Развёртывание: быстрый старт
0. [Установите Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) на сервер управления, свой компьютер или ноутбук
##### Пример 1 (установка, используя репозиторий [Astra Linux](https://wiki.astralinux.ru/pages/viewpage.action?pageId=27362819)):
`sudo apt update` \
`sudo apt install ansible` \

`--Установка пакета для работы с pyOpenSSL` \
`sudo apt-get install libssl-dev` \
`sudo pip3 install --upgrade pip` \
`sudo pip install pyOpenSSL`

##### Пример 2 (установка, используя [pip](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-with-pip) ):
`sudo apt update && sudo apt install python3-pip sshpass git -y` \
`sudo pip3 install ansible` \

`--Установка пакета для работы с pyOpenSSL` \
`sudo apt-get install libssl-dev` \
`sudo pip3 install --upgrade pip` \
`sudo pip install pyOpenSSL`

1. Скачайте или клонируйте этот репозиторий

`git clone https://github.com/IlgizMamyshev/pgsql_cluster.git`

2. Перейдите в каталог с файлами playbook

`cd pgsql_cluster/`

3. Отредактируйте файл инвентаризации

##### Задайте IP-адреса и параметры подключения (`ansible_user`, `ansible_ssh_pass` ...)

`vim inventory`

4. Отредактируйте значения переменных в файле vars/[main.yml](./vars/main.yml)

`vim vars/main.yml`

5. Проверьте доступность узлов

`ansible all -m ping`

6.1 Запустите playbook для установки кластера etcd (опционально, если используете etcd DCS вместо Patroni RAFT):

`ansible-playbook deploy_pgcluster.yml -K`

6.2 Запустите playbook для установки кластера PostgreSQL:

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
- затем, если используется etcd, удалите запись в etcd (можно запустить на любом узле etcd):
    ```shell 
    sudo ETCDCTL_API=2 etcdctl --ca-file="/etc/etcd/ssl/ca.crt" --endpoints https://127.0.0.1:2379 --cert-file=/etc/etcd/ssl/server.crt --key-file=/etc/etcd/ssl/server.key rm --dir --recursive /service/
    ```

---

## Лицензия
Под лицензией MIT License. Подробнее см. в файле [LICENSE](./LICENSE) .

## Автор
Илгиз Мамышев (Microsoft SQL Server, PostgreSQL DBA) \
[https://imamyshev.wordpress.com](https://imamyshev.wordpress.com/2022/05/29/dns-connection-point-for-patroni/) \
Виталий Кухарик (PostgreSQL DBA) - автор проекта [postgresql_cluster](https://github.com/vitabaks/postgresql_cluster) на кодовой базе которого построен [pgsql_cluster](https://github.com/IlgizMamyshev/pgsql_cluster/)

## Обратная связь, отчеты об ошибках, запросы и т.п.
[Добро пожаловать](https://github.com/IlgizMamyshev/pgsql_cluster/issues)!
