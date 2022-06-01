# PostgreSQL High-Availability Cluster with DNS Connection Point (DRAFT!!!!!!!!!)

[![GitHub license](https://img.shields.io/github/license/IlgizMamyshev/pgsql_cluster)](https://github.com/IlgizMamyshev/pgsql_cluster/blob/master/LICENSE) 
![GitHub stars](https://img.shields.io/github/stars/IlgizMamyshev/pgsql_cluster)

---
![Banner](https://user-images.githubusercontent.com/93491087/171470810-9437d5ea-0ef9-41b4-aa7e-85be1e97f4f1.png)

### Deploy a Production Ready PostgreSQL High-Availability Cluster (based on "Patroni" and "DCS(etcd)"). Automating with Ansible.

This Ansible playbook is designed for deploying a ...

...
...







##### PostgreSQL (databases)
Backup and restore tools:
* [pgbackrest](https://github.com/pgbackrest/pgbackrest)
* [pg_probackup](https://github.com/postgrespro/pg_probackup)
* [wal-g](https://github.com/wal-g/wal-g)

Do not forget to validate your backups.

## How to start from scratch
Should you need to start from very beginning, use the following to clean up:
- on all nodes, stop Patroni and remove PGDATA:
    ```shell
    sudo systemctl stop patroni
    sudo rm -rf /var/lib/postgresql/ # be careful with this if there are other PG clusters
    ```
- then delete etcd entry (can be run on any node):
    ```shell 
    etcdctl --username patroni-etcd:P@ssw0rd rm --dir --recursive /service/pgsql-cluster/ # adjust if you changed the cluster's name, user name and password.
    ```

---

## License
Licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.

## Author
Ilgiz Mamyshev (Microsoft SQL Server, PostgreSQL DBA) \
[https://imamyshev.wordpress.com](https://imamyshev.wordpress.com/2022/05/29/dns-connection-point-for-patroni/)

### Sponsor this project
[![Support me on Patreon](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Fshieldsio-patreon.vercel.app%2Fapi%3Fusername%3Dvitabaks%26type%3Dpatrons&style=for-the-badge)](https://patreon.com/imamyshev)

## Feedback, bug-reports, requests, ...
Are [welcome](https://github.com/IlgizMamyshev/pgsql_cluster/issues)!
