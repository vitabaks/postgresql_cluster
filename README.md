# PostgreSQL High-Availability Cluster
### PostgreSQL High-Availability Cluster (based on "Patroni" and "DCS(etcd)"). Automating deployment with Ansible.

This Ansible playbook is designed for deploying a PostgreSQL high availability cluster on dedicated physical servers for a production environment.
Сluster can be deployed in virtual machines for test environments and small projects.

This playbook support the deployment of cluster over already existing and running PostgreSQL. You must specify the variable postgresql_exists = 'true' in the inventory file. 
**Attention!** Your PostgreSQL will be stopped before running in cluster mode. You must planing downtime of existing databases.

**Please test it in your test enviroment before using in a production.**


You have two options available for deployment ("Type A" and "Type B"):

### [Type A] PostgreSQL High-Availability with Load Balancing
![TypeA](https://github.com/vitabaks/postgresql_cluster/blob/master/TypeA.png)

description will be added very soon ...

### [Type B] PostgreSQL High-Availability only
![TypeB](https://github.com/vitabaks/postgresql_cluster/blob/master/TypeB.png)

description will be added very soon ...


#### Compatibility
RedHat and Debian based distros.

###### minimum os versions:
- RedHat: 7
- CentOS: 7
- Ubuntu: 16.04
- Debian: 8

:white_check_mark: tested, works fine: Debian 9, Ubuntu 18.04, CentOS 7.

###### PostgreSQL versions: 
all supported PostgreSQL versions

:white_check_mark: tested, works fine: PostgreSQL 9.6, 10, 11.


#### Requirements
*coming soon...*


### Quick start
*coming soon...*


#### Variables
*coming soon...*

See the vars/[main.yml](https://github.com/vitabaks/postgresql_cluster/blob/master/vars/main.yml) file for details.


#### License
Licensed under the MIT License. See the [LICENSE](https://github.com/vitabaks/postgresql_cluster/blob/master/LICENSE) file for details.


#### Author
Vitaliy Kukharik (PostgreSQL DBA) vitabaks@gmail.com


#### Feedback, bug-reports, requests, ...
Are [welcome](https://github.com/vitabaks/postgresql_cluster/issues)!
