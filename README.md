# Высокодоступный геораспределённый кластер PostgreSQL на базе Patroni с DNS точкой клиентского доступа

[![GitHub license](https://img.shields.io/github/license/IlgizMamyshev/pgsql_cluster)](https://github.com/IlgizMamyshev/pgsql_cluster/blob/master/LICENSE) 
![GitHub stars](https://img.shields.io/github/stars/IlgizMamyshev/pgsql_cluster)

---
![Banner](https://github.com/IlgizMamyshev/pgsql_cluster/blob/master/doc/PostreSQLBanner1600x400.png)

### Развертывание кластера высокой доступности PostgreSQL, готового к производственной среде (на основе "Patroni" и "DCS (etcd)"). Автоматизация с помощью Ansible.

Этот Ansible playbook разработан для развёртывания высокодоступного кластера PostgreSQL на выделенных физических серверах для производственной среды.  
Развёртывание может быть выполнено в виртуальной среде для тестовой среды или небольших проектов.  

В дополнение к развертыванию новых кластеров этот playbook также поддерживает развертывание кластера поверх уже существующего и работающего PostgreSQL. Вы можете преобразовать выделенный экземпляр PostgreSQL в кластер высокой доступности (укажите переменную `postgresql_exists='true'` в файле инвентаризации).  
**Внимание!** Ваш экземпляр PostgreSQL будет остановлен перед запуском в составе кластера (пожалуйста, запланируйте небольшой простой баз данных).

> :heavy_exclamation_mark: Пожалуйста, проведите тестирование, прежде чем использовать в производственной среде.
  
![PGSQLCluster](https://github.com/IlgizMamyshev/pgsql_cluster/blob/master/doc/PGSQLCluster.png)
> Для развёртывания кластера без HAProxy задайте `with_haproxy_load_balancing: false` в файле переменных vars/main.yml

Описание в разработке..  
...  
...  






##### PostgreSQL (базы данных)
Рекомендуемые средства резервного копирования и восстановления:
* [pg_probackup](https://github.com/postgrespro/pg_probackup)

Не забывайте тестировать свои резервные копии.

## Как начать развёртывание с нуля
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

### Поддержать данный проект
[![Support me on Patreon](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Fshieldsio-patreon.vercel.app%2Fapi%3Fusername%3Dvitabaks%26type%3Dpatrons&style=for-the-badge)](https://patreon.com/imamyshev)

## Обратная связь, отчеты об ошибках, запросы и т.п.
[Добро пожаловать](https://github.com/IlgizMamyshev/pgsql_cluster/issues)!
