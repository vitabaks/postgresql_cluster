## Update PostgreSQL to the new major version

This role is designed for in-place major upgrades of PostgreSQL, e.g., from version 14 to 15.

**Database Downtime Considerations:**

To minimize or even eliminate errors during database upgrades (depending on the workload and timeouts), we pause the PgBouncer pools. From an application's perspective, this does not result in terminated database connections. Instead, applications might experience a temporary increase in query latency while the PgBouncer pools are paused.

On average, the PgBouncer pause duration is approximately 30 seconds. However, for larger databases, this pause might be extended due to longer `pg_upgrade` and `rsync` procedures. The default maximum wait time for a request during a pause is set to 2 minutes (controlled by the `query_wait_timeout` pgbouncer parameter). If the pause exceeds this duration, connections will be terminated with a timeout error.

#### Compatibility

The upgrade is supported starting from PostgreSQL 9.3 and up to the latest PostgreSQL version.

#### Requirements

There is no need to plan additional disk space, because when upgrading PostgreSQL using hard links instead of copying files. However, it is required that the `pg_old_datadir` and `pg_new_datadir` are located within the same top-level directory (`pg_upper_datadir` variable).

Specify the current (old) version of PostgreSQL in the `pg_old_version` variable and target version of PostgreSQL for the upgrade in the `pg_new_version` variable.

#### Usage

```
ansible-playbook pg_upgrade.yml -e "pg_old_version=14 pg_new_version=15"
```

#### Variables

| Variable Name | Description | Default Value |
|---------------|-------------|--------------:|
| `pg_old_version` | Current (old) version of PostgreSQL. | `""` |
| `pg_new_version` | Target version of PostgreSQL for the upgrade. | `""` |
| `pg_old_bindir` | Directory containing binaries for the old PostgreSQL version. | Derived value |
| `pg_old_datadir` | Data directory path for the old PostgreSQL version. | Derived value |
| `pg_old_confdir` | Configuration directory path for the old PostgreSQL version. | Derived value |
| `pg_new_bindir` | Directory containing binaries for the new PostgreSQL version. | Derived value |
| `pg_new_datadir` | Data directory path for the new PostgreSQL version. | Derived value |
| `pg_new_confdir` | Configuration directory path for the new PostgreSQL version. | Derived value |
| `pg_new_wal_dir` | Custom WAL directory for the new PostgreSQL version. | Derived value |
| `pg_upper_datadir` | Top-level directory containing both old and new PostgreSQL data directories. | Derived value |
| `pg_new_packages` | List of package names for the new PostgreSQL version to be installed. | Derived value |
| `pg_old_packages_remove` | Whether to remove old PostgreSQL packages after the upgrade. | `true` |
| `pg_start_stop_timeout` | Timeout when starting/stopping PostgreSQL during the upgrade (in seconds). | `1800` |
| `schema_compatibility_check` | Check database schema compatibility with the new PostgreSQL version before upgrading. | `true` |
| `schema_compatibility_check_port` | Port for temporary PostgreSQL instance for schema compatibility checking. | Derived value |
| `schema_compatibility_check_timeout` | Max duration for compatibility check (pg_dumpall --schema-only) in seconds. | `3600` |
| `vacuumdb_analyze_timeout` | Max duration of analyze command in seconds. | `3600` |
| `update_extensions` | Automatically update all PostgreSQL extensions. | `true` |
| `max_replication_lag_bytes` | Maximum allowed replication lag in bytes. | `10485760` |
| `max_transaction_sec` | Maximum allowed duration for a transaction in seconds. | `15` |
| `copy_files_to_all_server` | Copy files located in the "files" directory to all servers. (optional) | `[]` |
| `pgbouncer_pool_pause` | Pause pgbouncer pools during upgrade. | `true` |
| `pgbouncer_pool_pause_terminate_after` | Time in seconds after which script terminates slow active queries. | `30` |
| `pgbouncer_pool_pause_stop_after` | Time in seconds after which the script exits with an error if unable to pause all pgbouncer pools. | `60` |
| `pg_slow_active_query_treshold` | Time in milliseconds to wait for active queries before trying to pause the pool. | `1000` |
| `pg_slow_active_query_treshold_to_terminate` | Time in milliseconds after reaching "pgbouncer_pool_pause_terminate_after" before the script terminates active queries. | `100` |

Note: For variables marked as "Derived value", the default value is determined based on other variables. \
Please see the variable file vars/[upgrade.yml](../../vars/upgrade.yml)

---

### Upgrade Plan:

#### 1. PRE-UPGRADE: Perform Pre-Checks
- Make sure that the required variables `pg_old_version`, `pg_new_version` are specified
  - Stop, if one or more required variables have empty values.
- Ensure pg_old and pg_new data and config dirs are not the same
  - Stop, if `pg_old_datadir` and `pg_new_datadir`, or `pg_old_confdir` and `pg_new_confdir` match.
- Make sure the ansible required Python library 'pexpect' is installed
- Test PostgreSQL database access using a unix socket
  - if there is an error (no pg_hba.conf entry), add temporary local access rule (during the upgrade)
- Check the current version of PostgreSQL
  - Stop, if the current version does not match `pg_old_version`
  - Stop, if the current version greater than or equal to `pg_new_version` 
- Ensure new data directory is different from the current one
  - Stop, if the current data directory is the same as `pg_new_datadir`
  - Stop, if the current WAL directory is the same as `pg_new_wal_dir` (if a custom wal dir is used)
  - Note: This check is necessary to avoid the risk of deleting the current data directory
- Make sure that physical replication is active
  - Stop, if there are no active replicas
- Make sure there is no high replication lag
  - Stop, if replication lag is high (more than `max_replication_lag_bytes`)
- Make sure there are no long-running transactions
  - Stop, if long-running transactions detected (more than `max_transaction_sec`)
- Make sure that SSH key-based authentication is configured between cluster nodes
  - Create and copy ssh keys between database servers (if not configured)
- Rsync Checks
  - Make sure that the rsync package are installed
  - Create 'testrsync' file on Primary
  - Test rsync and ssh key access
  - Cleanup 'testrsync' file
- Check if PostgreSQL tablespaces exist
  - Print tablespace location (if exists)
  - Note: If tablespaces are present they will be upgraded (step 5) on replicas using rsync
- Test PgBouncer access via localhost 
  - test access via 'localhost' to be able to perform 'PAUSE' command

#### 2. PRE-UPGRADE: Install new PostgreSQL packages
- Clean yum/dnf cache (for RedHat based) or Update apt cache for (Debian based)
- Install new PostgreSQL packages
- Install TimescaleDB package for new PostgreSQL
  - Note: if 'enable_timescale' is 'true'

#### 3. PRE-UPGRADE: Initialize new db, schema compatibility check, and pg_upgrade --check
- Initialize new db
  - Make sure new PostgreSQL data directory exists
  - Make sure new PostgreSQL data directory is not initialized
    - If already initialized:
      - Perform pg_dropcluster (for Debian based)
      - Clear the new PostgreSQL data directory
  - Get the current install user (rolname with oid = 10)
  - Get the current encodig and data_checksums settings
  - Initialize new PostgreSQL data directory
    - for Debain based: on all database servers to create default config files
    - for RedHat based: on the Primary only
  - (optional) Copy files specified in the `copy_files_to_all_server` variable
    - Notes: for example, it may be necessary for Postgres Full-Text Search (FTS) files 
- Schema compatibility check
  - Get the current `shared_preload_libraries` settings
  - Get the current cron.database_name settings
    - Notes: if 'pg_cron' is defined in 'pg_shared_preload_libraries'
  - Start new PostgreSQL to check the schema compatibility
    - Note: on the port specified in the `schema_compatibility_check_port` variable
  - Wait for PostgreSQL to start
  - Check the compatibility of the database schema with the new PostgreSQL
    - Notes: used `pg_dumpall` with `--schema-only` options
  - Wait for the schema compatibility check to complete
  - Checking the result of the schema compatibility
    - Note: Checking for errors in `/tmp/pg_schema_compatibility_check.log`
    - Stop, if the scheme is not compatible (there are errors)
  - Print result of checking the compatibility of the scheme
  - Stop new PostgreSQL to re-initdb
  - Drop new PostgreSQL to re-initdb (perform pg_dropcluster for Debian based)
  - Reinitialize the database after checking schema compatibility
- pg_upgrade check
  - Get the current `shared_preload_libraries` settings
  - Verify the two clusters are compatible (`pg_upgrade --check`)
  - Print the result of the pg_upgrade check

#### 4. PRE-UPGRADE: Prepare the Patroni configuration
- Edit patroni.yml
  - Update parameters: `data_dir`, `bin_dir`, `config_dir`
  - Check if the 'standby_cluster' parameter is specified
    - Remove parameters: `standby_cluster` (if exists)
    - Notes: To support upgrades in the Patroni Standby Cluster
  - Prepare the parameters for PostgreSQL (removed or renamed parameters)
    - Check if the '`replacement_sort_tuples`' parameter is specified (removed in PG 11)
      - remove parameter: 'replacement_sort_tuples' (if exists)
    - Check if the '`default_with_oids`' parameter is specified (removed in PG 12)
      - remove parameter: 'default_with_oids' (if exists)
    - Check if the '`wal_keep_segments`' parameter is specified (removed in PG 13)
      - replace parameter: 'wal_keep_segments' to '`wal_keep_size`'
    - Check if the '`operator_precedence_warning`' parameter is specified" (removed in PG 14)
      - remove parameter: 'operator_precedence_warning' (if exists)
    - Check if the '`vacuum_cleanup_index_scale_factor`' parameter is specified (removed in PG 14)
      - remove parameter: 'vacuum_cleanup_index_scale_factor' (if exists)
    - Check if the '`stats_temp_directory`' parameter is specified (removed in PG 15)
      - remove parameter: 'stats_temp_directory' (if exists)
- Copy pg_hba.conf to `pg_new_confdir`
  - Notes: to save pg_hba rules

#### 5. UPGRADE: Upgrade PostgreSQL

#### 6. POST-UPGRADE: Perform Post-Checks and Update extensions

#### 7. POST-UPGRADE: Analyze a PostgreSQL database (update optimizer statistics) and Post-Upgrade tasks
