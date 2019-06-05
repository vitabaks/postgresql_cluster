# PostgreSQL High-Availability Cluster :elephant: :sparkling_heart:
### PostgreSQL High-Availability Cluster (based on "Patroni" and "DCS(etcd)"). Automating deployment with Ansible.

This Ansible playbook is designed for deploying a PostgreSQL high availability cluster on dedicated physical servers for a production environment.
Сluster can be deployed in virtual machines for test environments and small projects.

This playbook support the deployment of cluster over already existing and running PostgreSQL. You must specify the variable `postgresql_exists = 'true'` in the inventory file. 
**Attention!** Your PostgreSQL will be stopped before running in cluster mode. You must planing downtime of existing databases.
```
Please test it in your test enviroment before using in a production.
```

You have two options available for deployment ("Type A" and "Type B"):

### [Type A] PostgreSQL High-Availability with Load Balancing
![TypeA](https://github.com/vitabaks/postgresql_cluster/blob/master/TypeA.png)

description will be added very soon ...

### [Type B] PostgreSQL High-Availability only
![TypeB](https://github.com/vitabaks/postgresql_cluster/blob/master/TypeB.png)

description will be added very soon ...

---
#### Compatibility
RedHat and Debian based distros.

###### Minimum OS versions:
- RedHat: 7
- CentOS: 7
- Ubuntu: 16.04
- Debian: 8

:white_check_mark: tested, works fine: `Debian 9, Ubuntu 18.04, CentOS 7`

###### PostgreSQL versions: 
all supported PostgreSQL versions

:white_check_mark: tested, works fine: `PostgreSQL 9.6, 10, 11`

###### Ansible version 
This has been tested on Ansible 2.7.10 and higher.

#### Requirements
Ansible ([What is Ansible](https://www.ansible.com/resources/videos/quick-start-video)?)

---

### Quick start
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

###### Minimum set of variables: 
- `cluster_vip`
- `patroni_cluster_name`
- `with_haproxy_load_balancing` `'true'` (Type A) or `'false'`/default (Type B)
- `postgresql_version`
- `proxy_env`

`vim vars/main.yml`

5. Run playbook:

`ansible-playbook deploy_pgcluster.yml`

---

#### Variables
*coming soon...*

See the vars/[main.yml](./vars/main.yml) file for details.

---
#### License
Licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.


#### Author
Vitaliy Kukharik (PostgreSQL DBA) vitabaks@gmail.com


#### Feedback, bug-reports, requests, ...
Are [welcome](https://github.com/vitabaks/postgresql_cluster/issues)!
