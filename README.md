# PostgreSQL High-Availability Cluster :elephant: :sparkling_heart:

[<img src="https://github.com/vitabaks/postgresql_cluster/workflows/Ansible-lint/badge.svg?branch=master">](https://github.com/vitabaks/postgresql_cluster/actions?query=workflow%3AAnsible-lint)
[<img src="https://github.com/vitabaks/postgresql_cluster/workflows/Yamllint/badge.svg?branch=master">](https://github.com/vitabaks/postgresql_cluster/actions?query=workflow%3AYamllint)
[<img src="https://github.com/vitabaks/postgresql_cluster/workflows/Flake8/badge.svg?branch=master">](https://github.com/vitabaks/postgresql_cluster/actions?query=workflow%3AFlake8)
[<img src="https://github.com/vitabaks/postgresql_cluster/workflows/Molecule/badge.svg?branch=master">](https://github.com/vitabaks/postgresql_cluster/actions?query=workflow%3AMolecule)
[![GitHub license](https://img.shields.io/github/license/vitabaks/postgresql_cluster)](https://github.com/vitabaks/postgresql_cluster/blob/master/LICENSE) 
![GitHub stars](https://img.shields.io/github/stars/vitabaks/postgresql_cluster)

### Production-ready PostgreSQL High-Availability Cluster (based on Patroni). Automating with Ansible.

`postgresql_cluster` automates the deployment and management of highly available PostgreSQL clusters in production environments. This solution is tailored for use on dedicated physical servers, virtual machines, and within both on-premises and cloud-based infrastructures.

You can find a version of this documentation that is searchable and also easier to navigate at [postgresql-cluster.org](http://postgresql-cluster.org)

:trophy: **Use the [sponsoring](https://github.com/vitabaks/postgresql_cluster#sponsor-this-project) program to get personalized support, or just to contribute to this project.**

---

### Supported setups of Postgres Cluster

![postgresql_cluster](images/postgresql_cluster.png#gh-light-mode-only)
![postgresql_cluster](images/postgresql_cluster.dark_mode.png#gh-dark-mode-only)

You have three schemes available for deployment:

#### 1. PostgreSQL High-Availability only

This is simple scheme without load balancing.

##### Components:

- [**Patroni**](https://github.com/zalando/patroni) is a template for you to create your own customized, high-availability solution using Python and - for maximum accessibility - a distributed configuration store like ZooKeeper, etcd, Consul or Kubernetes. Used for automate the management of PostgreSQL instances and auto failover.

- [**etcd**](https://github.com/etcd-io/etcd) is a distributed reliable key-value store for the most critical data of a distributed system. etcd is written in Go and uses the [Raft](https://raft.github.io/) consensus algorithm to manage a highly-available replicated log. It is used by Patroni to store information about the status of the cluster and PostgreSQL configuration parameters. [What is Distributed Consensus?](http://thesecretlivesofdata.com/raft/)

- [**vip-manager**](https://github.com/cybertec-postgresql/vip-manager) (_optional, if the `cluster_vip` variable is specified_) is a service that gets started on all cluster nodes and connects to the DCS. If the local node owns the leader-key, vip-manager starts the configured VIP. In case of a failover, vip-manager removes the VIP on the old leader and the corresponding service on the new leader starts it there. Used to provide a single entry point (VIP) for database access.

- [**PgBouncer**](https://pgbouncer.github.io/features.html) (optional, if the `pgbouncer_install` variable is `true`) is a connection pooler for PostgreSQL.

#### 2. PostgreSQL High-Availability with Load Balancing

This scheme enables load distribution for read operations and also allows for scaling out the cluster with read-only replicas.

When deploying to cloud providers such as AWS, GCP, Azure, DigitalOcean, and Hetzner Cloud, a cloud load balancer is automatically created by default to provide a single entry point to the database (controlled by the `cloud_load_balancer` variable).

For non-cloud environments, such as when deploying on Your Own Machines, the HAProxy load balancer is available for use. To enable it, set `with_haproxy_load_balancing: true` in the vars/main.yml file.

> [!NOTE]
> Your application must have support sending read requests to a custom port 5001, and write requests to port 5000.

List of ports when using HAProxy:
- port 5000 (read / write) master
- port 5001 (read only) all replicas
- port 5002 (read only) synchronous replica only
- port 5003 (read only) asynchronous replicas only

##### Components of HAProxy load balancing:

- [**HAProxy**](http://www.haproxy.org/) is a free, very fast and reliable solution offering high availability, load balancing, and proxying for TCP and HTTP-based applications. 

- [**confd**](https://github.com/kelseyhightower/confd) manage local application configuration files using templates and data from etcd or consul. Used to automate HAProxy configuration file management.

- [**Keepalived**](https://github.com/acassen/keepalived)  (_optional, if the `cluster_vip` variable is specified_) provides a virtual high-available IP address (VIP) and single entry point for databases access.
Implementing VRRP (Virtual Router Redundancy Protocol) for Linux. In our configuration keepalived checks the status of the HAProxy service and in case of a failure delegates the VIP to another server in the cluster.

#### 3. PostgreSQL High-Availability with Consul Service Discovery

To use this scheme, specify `dcs_type: consul` in variable file vars/main.yml

This scheme is suitable for master-only access and for load balancing (using DNS) for reading across replicas. Consul [Service Discovery](https://developer.hashicorp.com/consul/docs/concepts/service-discovery) with [DNS resolving ](https://developer.hashicorp.com/consul/docs/discovery/dns) is used as a client access point to the database.

Client access point (example):

- `master.postgres-cluster.service.consul`
- `replica.postgres-cluster.service.consul`

Besides, it can be useful for a distributed cluster across different data centers. We can specify in advance which data center the database server is located in and then use this for applications running in the same data center. 

Example: `replica.postgres-cluster.service.dc1.consul`, `replica.postgres-cluster.service.dc2.consul`

It requires the installation of a consul in client mode on each application server for service DNS resolution (or use [forward DNS](https://developer.hashicorp.com/consul/tutorials/networking/dns-forwarding?utm_source=docs) to the remote consul server instead of installing a local consul client).

## Compatibility
RedHat and Debian based distros (x86_64)

###### Supported Linux Distributions:
- **Debian**: 11, 12
- **Ubuntu**: 22.04, 24.04
- **CentOS Stream**: 9
- **Oracle Linux**: 8, 9
- **Rocky Linux**: 8, 9
- **AlmaLinux**: 8, 9

###### PostgreSQL versions: 
all supported PostgreSQL versions

:white_check_mark: tested, works fine: PostgreSQL 10, 11, 12, 13, 14, 15, 16

_Table of results of daily automated testing of cluster deployment:_
| Distribution | Test result |
|--------------|:----------:|
| Debian 11    | [![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/vitabaks/postgresql_cluster/schedule_pg_debian11.yml?branch=master)](https://github.com/vitabaks/postgresql_cluster/actions/workflows/schedule_pg_debian11.yml) |
| Debian 12    | [![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/vitabaks/postgresql_cluster/schedule_pg_debian11.yml?branch=master)](https://github.com/vitabaks/postgresql_cluster/actions/workflows/schedule_pg_debian12.yml) |
| Ubuntu 22.04 | [![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/vitabaks/postgresql_cluster/schedule_pg_ubuntu2204.yml?branch=master)](https://github.com/vitabaks/postgresql_cluster/actions/workflows/schedule_pg_ubuntu2204.yml) |
| Ubuntu 24.04 | [![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/vitabaks/postgresql_cluster/schedule_pg_ubuntu2204.yml?branch=master)](https://github.com/vitabaks/postgresql_cluster/actions/workflows/schedule_pg_ubuntu2404.yml) |
| CentOS Stream 9 | [![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/vitabaks/postgresql_cluster/schedule_pg_centosstream9.yml?branch=master)](https://github.com/vitabaks/postgresql_cluster/actions/workflows/schedule_pg_centosstream9.yml) |
| Oracle Linux 8 | [![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/vitabaks/postgresql_cluster/schedule_pg_oracle_linux8.yml?branch=master)](https://github.com/vitabaks/postgresql_cluster/actions/workflows/schedule_pg_oracle_linux8.yml) |
| Oracle Linux 9 | [![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/vitabaks/postgresql_cluster/schedule_pg_oracle_linux9.yml?branch=master)](https://github.com/vitabaks/postgresql_cluster/actions/workflows/schedule_pg_oracle_linux9.yml) |
| Rocky Linux 8 | [![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/vitabaks/postgresql_cluster/schedule_pg_rockylinux8.yml?branch=master)](https://github.com/vitabaks/postgresql_cluster/actions/workflows/schedule_pg_rockylinux8.yml) |
| Rocky Linux 9 | [![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/vitabaks/postgresql_cluster/schedule_pg_rockylinux9.yml?branch=master)](https://github.com/vitabaks/postgresql_cluster/actions/workflows/schedule_pg_rockylinux9.yml) |
| AlmaLinux 8 | [![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/vitabaks/postgresql_cluster/schedule_pg_almalinux8.yml?branch=master)](https://github.com/vitabaks/postgresql_cluster/actions/workflows/schedule_pg_almalinux8.yml) |
| AlmaLinux 9 | [![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/vitabaks/postgresql_cluster/schedule_pg_almalinux9.yml?branch=master)](https://github.com/vitabaks/postgresql_cluster/actions/workflows/schedule_pg_almalinux9.yml) |

###### Ansible version 
Minimum supported Ansible version: 8.0.0 (ansible-core 2.15.0)

## Requirements

<details><summary>Click here to expand...</summary><p>

This playbook requires root privileges or sudo.

Ansible ([What is Ansible](https://www.ansible.com/how-ansible-works/)?)

if dcs_type: "consul", please install consul role requirements on the control node:

`ansible-galaxy install -r roles/consul/requirements.yml`

### Port requirements
List of required TCP ports that must be open for the database cluster:

- `5432` (postgresql)
- `6432` (pgbouncer)
- `8008` (patroni rest api)
- `2379`, `2380` (etcd)

for the scheme "[Type A] PostgreSQL High-Availability with Load Balancing":

- `5000` (haproxy - (read/write) master)
- `5001` (haproxy - (read only) all replicas)
- `5002` (haproxy - (read only) synchronous replica only)
- `5003` (haproxy - (read only) asynchronous replicas only)
- `7000` (optional, haproxy stats)

for the scheme "[Type C] PostgreSQL High-Availability with Consul Service Discovery (DNS)":

- `8300` (Consul Server RPC)
- `8301` (Consul Serf LAN)
- `8302` (Consul Serf WAN)
- `8500` (Consul HTTP API)
- `8600` (Consul DNS server)

</p></details>

## Recommenations

<details><summary>Click here to expand...</summary><p>

- **linux (Operation System)**: 

Update your operating system on your target servers before deploying;

Make sure you have time synchronization is configured (NTP).
Specify `ntp_enabled:'true'` and `ntp_servers` if you want to install and configure the ntp service.

- **DCS (Distributed Consensus Store)**: 

Fast drives and a reliable network are the most important factors for the performance and stability of an etcd (or consul) cluster.

Avoid storing etcd (or consul) data on the same drive along with other processes (such as the database) that are intensively using the resources of the disk subsystem! 
Store the etcd and postgresql data on **different** disks (see `etcd_data_dir`, `consul_data_path` variables), use ssd drives if possible.
See [hardware recommendations](https://etcd.io/docs/v3.3/op-guide/hardware/) and [tuning](https://etcd.io/docs/v3.3/tuning/) guides.

It is recommended to deploy the DCS cluster on dedicated servers, separate from the database servers.

- **Placement of cluster members in different data centers**:

If you’d prefer a cross-data center setup, where the replicating databases are located in different data centers, etcd member placement becomes critical.

There are quite a lot of things to consider if you want to create a really robust etcd cluster, but there is one rule: *do not placing all etcd members in your primary data center*. See some [examples](https://www.cybertec-postgresql.com/en/introduction-and-how-to-etcd-clusters-for-patroni/).


- **How to prevent data loss in case of autofailover (synchronous_modes)**:

Due to performance reasons, a synchronous replication is disabled by default.

To minimize the risk of losing data on autofailover, you can configure settings in the following way:
- synchronous_mode: 'true'
- synchronous_mode_strict: 'true'
- synchronous_commit: 'on' (or 'remote_apply')

</p></details>

## Getting Started

You have the option to easily deploy Postgres clusters using the Console (UI) or from the command line with the ansible-playbook command.

### Console (UI)

To run the PostgreSQL Cluster Console, execute the following command:

```
docker run -d --name pg-console \
  --publish 80:80 \
  --publish 8080:8080 \
  --env PG_CONSOLE_API_URL=http://localhost:8080/api/v1 \
  --env PG_CONSOLE_AUTHORIZATION_TOKEN=secret_token \
  --env PG_CONSOLE_DOCKER_IMAGE=vitabaks/postgresql_cluster:latest \
  --volume console_postgres:/var/lib/postgresql \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  --volume /tmp/ansible:/tmp/ansible \
  --restart=unless-stopped \
  vitabaks/postgresql_cluster_console:2.0.0
```

> [!TIP]
> It is recommended to run the console in the same network as your database servers to enable monitoring of the cluster status. In this case, replace `localhost` with your server's IP address in the PG_CONSOLE_API_URL variable.

**Open the Console UI**:

Go to http://localhost/ and use `secret_token` for authorization.

> [!NOTE]
> If you have set up the console on a different server, replace 'localhost' with the server's address. Use the value of your token if you have redefined it in the PG_CONSOLE_AUTHORIZATION_TOKEN variable.

![Cluster creation demo](images/pg_console_create_cluster_demo.gif)

Refer to the [Deployment](https://postgresql-cluster.org/category/deployment) section to learn more about the different deployment methods.

### Command line

<details><summary>Click here to expand... if you prefer the command line.</summary><p>

0. [Install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) on one control node (which could easily be a laptop)

```
sudo apt update && sudo apt install -y python3-pip sshpass git
pip3 install ansible
```

1. Download or clone this repository

```
git clone https://github.com/vitabaks/postgresql_cluster.git
```

2. Go to the automation directory

```
cd postgresql_cluster/automation
```

3. Install requirements on the control node

```
ansible-galaxy install --force -r requirements.yml 
```

Note: If you plan to use Consul (`dcs_type: consul`), install the consul role requirements
```
ansible-galaxy install -r roles/consul/requirements.yml
```

4. Edit the inventory file

Specify (non-public) IP addresses and connection settings (`ansible_user`, `ansible_ssh_pass` or `ansible_ssh_private_key_file` for your environment

```
nano inventory
```

5. Edit the variable file vars/[main.yml](./automation/vars/main.yml)

```
nano vars/main.yml
```

Minimum set of variables: 
- `proxy_env` to download packages in environments without direct internet access (optional)
- `patroni_cluster_name`
- `postgresql_version`
- `postgresql_data_dir`
- `cluster_vip` to provide a single entry point for client access to databases in the cluster (optional)
- `with_haproxy_load_balancing` to enable load balancing (optional)
- `dcs_type` "etcd" (default) or "consul"

See the vars/[main.yml](./automation/vars/main.yml), [system.yml](./automation/vars/system.yml) and ([Debian.yml](./automation/vars/Debian.yml) or [RedHat.yml](./automation/vars/RedHat.yml)) files for more details.

6. Try to connect to hosts

```
ansible all -m ping
```

7. Run playbook:

```
ansible-playbook deploy_pgcluster.yml
```

#### Deploy Cluster with TimescaleDB

To deploy a PostgreSQL High-Availability Cluster with the [TimescaleDB](https://github.com/timescale/timescaledb) extension, add the `enable_timescale` variable:

Example:
```
ansible-playbook deploy_pgcluster.yml -e "enable_timescale=true"
```

[![asciicast](https://asciinema.org/a/251019.svg)](https://asciinema.org/a/251019?speed=5)

### How to start from scratch

If you need to start from the very beginning, you can use the playbook `remove_cluster.yml`.

Available variables:
- `remove_postgres`: stop the PostgreSQL service and remove data.
- `remove_etcd`: stop the ETCD service and remove data.
- `remove_consul`: stop the Consul service and remove data.

Run the following command to remove specific components:

```bash
ansible-playbook remove_cluster.yml -e "remove_postgres=true remove_etcd=true"
```

This command will delete the specified components, allowing you to start a new installation from scratch.

:warning: **Caution:** be careful when running this command in a production environment.

</p></details>

## Star us

If you find our project helpful, consider giving it a star on GitHub! Your support helps us grow and motivates us to keep improving. Starring the project is a simple yet effective way to show your appreciation and help others discover it.

<a href="https://star-history.com/#vitabaks/postgresql_cluster&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=vitabaks/postgresql_cluster&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=vitabaks/postgresql_cluster&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=vitabaks/postgresql_cluster&type=Date" />
 </picture>
</a>

## Sponsor this project

By sponsoring our project, you directly contribute to its continuous improvement and innovation. As a sponsor, you'll receive exclusive benefits, including personalized support, early access to new features, and the opportunity to influence the project's direction. Your sponsorship is invaluable to us and helps ensure the project's sustainability and progress.

Become a sponsor today and help us take this project to the next level!

Support our work through [GitHub Sponsors](https://github.com/sponsors/vitabaks)

[![GitHub Sponsors](https://img.shields.io/github/sponsors/vitabaks?style=for-the-badge)](https://github.com/sponsors/vitabaks)

Support our work through [Patreon](https://www.patreon.com/vitabaks)

[![Support me on Patreon](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Fshieldsio-patreon.vercel.app%2Fapi%3Fusername%3Dvitabaks%26type%3Dpatrons&style=for-the-badge)](https://patreon.com/vitabaks)

Support our work through a crypto wallet:

USDT (TRC20): `TSTSXZzqDCUDHDjZwCpuBkdukjuDZspwjj`

## License
Licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.

## Author
Vitaliy Kukharik (PostgreSQL DBA) \
vitabaks@gmail.com

## Feedback, bug-reports, requests, ...
Are [welcome](https://github.com/vitabaks/postgresql_cluster/issues)!
