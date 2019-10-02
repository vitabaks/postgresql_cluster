# PostgreSQL High-Availability Cluster :elephant: :sparkling_heart:
### PostgreSQL High-Availability Cluster (based on "Patroni" and "DCS(etcd)"). Automating deployment with Ansible.

This Ansible playbook is designed for deploying a PostgreSQL high availability cluster on dedicated physical servers for a production environment.
Сluster can be deployed in virtual machines for test environments and small projects.

This playbook support the deployment of cluster over already existing and running PostgreSQL. You must specify the variable `postgresql_exists='true'` in the inventory file. 
**Attention!** Your PostgreSQL will be stopped before running in cluster mode. You must planing downtime of existing databases.

> :heavy_exclamation_mark: Please test it in your test enviroment before using in a production.


You have two options available for deployment ("Type A" and "Type B"):

### [Type A] PostgreSQL High-Availability with Load Balancing
![TypeA](https://github.com/vitabaks/postgresql_cluster/blob/master/TypeA.png)

> To use this scheme, specify `with_haproxy_load_balancing: 'true'` in variable file vars/main.yml

This scheme provides the ability to distribute the load on reading. This also allows us to scale out the cluster (with read-only replicas).

- port 5000 (read / write) master
- port 5001 (read only) all replicas

###### if variable "synchronous_mode" is 'true' (vars/main.yml):
- port 5002 (read only) synchronous replica only
- port 5003 (read only) asynchronous replicas only

> :heavy_exclamation_mark: Your application must have support sending read requests to a custom port (ex 5001), and write requests (ex 5000).

##### Components of high availability:
[**Patroni**](https://github.com/zalando/patroni) is a template for you to create your own customized, high-availability solution using Python and - for maximum accessibility - a distributed configuration store like ZooKeeper, etcd, Consul or Kubernetes. Used for automate the management of PostgreSQL instances and auto failover.

[**etcd**](https://github.com/etcd-io/etcd) is a distributed reliable key-value store for the most critical data of a distributed system. etcd is written in Go and uses the [Raft](https://raft.github.io/) consensus algorithm to manage a highly-available replicated log. It is used by Patroni to store information about the status of the cluster and PostgreSQL configuration parameters.

[What is Distributed Consensus?](http://thesecretlivesofdata.com/raft/)

##### Components of load balancing:
[**HAProxy**](http://www.haproxy.org/) is a free, very fast and reliable solution offering high availability, load balancing, and proxying for TCP and HTTP-based applications. 

[**confd**](https://github.com/kelseyhightower/confd) manage local application configuration files using templates and data from etcd or consul. Used to automate HAProxy configuration file management.

[**Keepalived**](https://github.com/acassen/keepalived) provides a virtual high-available IP address (VIP) and single entry point for databases access.
Implementing VRRP (Virtual Router Redundancy Protocol) for Linux.
In our configuration keepalived checks the status of the HAProxy service and in case of a failure delegates the VIP to another server in the cluster.

[**PgBouncer**](https://pgbouncer.github.io/features.html) is a connection pooler for PostgreSQL.



### [Type B] PostgreSQL High-Availability only
![TypeB](https://github.com/vitabaks/postgresql_cluster/blob/master/TypeB.png)

This is simple scheme without load balancing `Used by default`

To provide a single entry point (VIP) for databases access is used "vip-manager".

[**vip-manager**](https://github.com/cybertec-postgresql/vip-manager) manages a virtual IP (VIP) based on state kept in etcd or Consul. Is written in Go.  :copyright:  Cybertec Schönig & Schönig GmbH https://www.cybertec-postgresql.com



---
## Compatibility
RedHat and Debian based distros (x86_64)

###### Minimum OS versions:
- RedHat: 7
- CentOS: 7
- Ubuntu: 16.04
- Debian: 8

:white_check_mark: tested, works fine: `Debian 9/10, Ubuntu 18.04, CentOS 7.6`

###### PostgreSQL versions: 
all supported PostgreSQL versions

:white_check_mark: tested, works fine: `PostgreSQL 9.6, 10, 11`

###### Ansible version 
This has been tested on Ansible 2.7.10 and higher.

## Requirements
This playbook requires root privileges or sudo.

Ansible ([What is Ansible](https://www.ansible.com/resources/videos/quick-start-video)?)

## Recommendations
- **linux (Operation System)**: 

Update your operating system on your target servers before deploying;

Make sure you have time synchronization is configured (NTP).
Specify `ntp_enabled:'true'` and `ntp_servers` if you want to install and configure the ntp service.

- **DCS (Distributed Configuration Store)**: 

Fast drives and a reliable network are the most important factors for the performance and stability of an etcd cluster.

Avoid storing etcd data on the same drive along with other processes (such as the database) that are intensively using the resources of the disk subsystem! 
Store the etcd and postgresql data on **different** disks (see `etcd_data_dir` variable), use ssd drives if possible.
See [hardware recommendations](https://etcd.io/docs/v3.3.12/op-guide/hardware/) and [tuning](https://etcd.io/docs/v3.3.12/tuning/) guides.

Overloaded (highload) database clusters may require the installation of the etcd cluster on dedicated servers, separate from the database servers.

---

## Quick start
0. [Install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) to the managed machine
###### My recommendation: latest releases via [Pip](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#latest-releases-via-pip)

1. Download or clone this repository

`git clone https://github.com/vitabaks/postgresql_cluster.git`

###### To use a proxy server, specify `--config "http.proxy=proxy_server:port"`

2. Go to the playbook directory

`cd postgresql_cluster/`

3. Edit the inventory file

###### Specify the ip addresses and connection settings (`ansible_user`, `ansible_ssh_pass` ...) for your environment

`vim inventory`

4. Edit the variable file vars/[main.yml](./vars/main.yml)

`vim vars/main.yml`

###### Minimum set of variables: 
- `proxy_env` (for offline installation)

example:
```
proxy_env:
  http_proxy: http://proxy_server_ip:port
  https_proxy: http://proxy_server_ip:port
```
- `cluster_vip`
- `patroni_cluster_name`
- `with_haproxy_load_balancing` `'true'` (Type A) or `'false'`/default (Type B)
- `postgresql_version`


5. Run playbook:

`ansible-playbook deploy_pgcluster.yml`

[![asciicast](https://asciinema.org/a/251019.svg)](https://asciinema.org/a/251019?speed=5)

---

## Variables
See the vars/[main.yml](./vars/main.yml) and ([Debian.yml](./vars/Debian.yml) or [RedHat.yml](./vars/RedHat.yml)) files for more details.


## Maintenance
Please note that the original design goal of this playbook was more concerned with the initial deploiment of a PostgreSQL HA Cluster and so it does not currently concern itself with performing ongoing maintenance of a cluster.

You should learn each component of the cluster for its further maintenance.

- [Tutorial: Management of High-Availability PostgreSQL clusters with Patroni](https://pgconf.ru/en/2018/108567)
- [Patroni documentation](https://patroni.readthedocs.io/en/latest/)
- [etcd operations guide](https://etcd.io/docs/v3.3.12/op-guide/)

## Disaster Recovery
> Involves a set of policies, tools and procedures to enable the recovery or continuation of vital technology infrastructure and systems following a natural or human-induced disaster.

A high availability cluster provides an automatic failover mechanism, and does not cover all disaster recovery scenarios.
You must take care of backing up your data yourself.
##### etcd
> Patroni nodes are dumping the state of the DCS options to disk upon for every change of the configuration into the file patroni.dynamic.json located in the Postgres data directory. The master (patroni leader) is allowed to restore these options from the on-disk dump if these are completely absent from the DCS or if they are invalid.

However, I recommend that you read the disaster recovery guide for the etcd cluster:
- [etcd disaster recovery](https://etcd.io/docs/v3.3.12/op-guide/recovery)

##### PostgreSQL (databases)
I can recommend the following backup and restore tools:
* [pgbackrest](https://github.com/pgbackrest/pgbackrest)
* [pg_probackup](https://github.com/postgrespro/pg_probackup)
* [wal-g](https://github.com/wal-g/wal-g)

Do not forget to validate your backups (for example [pgbackrest auto](https://github.com/vitabaks/pgbackrest_auto)).

---

## License
Licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.

## Author
Vitaliy Kukharik (PostgreSQL DBA) vitabaks@gmail.com


## Feedback, bug-reports, requests, ...
Are [welcome](https://github.com/vitabaks/postgresql_cluster/issues)!
