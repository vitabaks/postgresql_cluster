## Database Schema for PostgreSQL Cluster Console

### Introduction

This project uses [Flyway](https://flywaydb.org) for versioning and managing database schema changes. Flyway is a database migration tool that enables database version control, much like Git does for source code. It allows to define and track changes in database schema over time, ensuring consistency and reproducibility.

For more information on using Flyway from the command line, see the [Flyway CLI documentation](https://documentation.red-gate.com/flyway/flyway-cli-and-api/usage/command-line).

### Database Migrations
Database migrations are SQL scripts that modify the schema of database. Each migration script should be placed in the `console/db/deploy` directory and follow Flyway's naming convention to ensure they are applied in the correct order.

**Naming Convention**
Flyway uses a specific naming convention to order and apply migrations:

- Versioned Migrations: These migrations have a version number and are applied in sequence. The naming format is `V<version>__<description>.sql`
  - Example: `V2.0.0__initial_scheme_setup.sql`
- Repeatable Migrations: These migrations do not have a version number and are applied every time they are changed. The naming format is `R__<description>.sql`

Example migrations:
```shell
flyway -url=jdbc:postgresql://<host>:5432/postgres \
  -user=postgres \
  -password=<password> \
  -locations=filesystem:./console/db/deploy \
  -baselineOnMigrate=true \
  migrate
```

### Validating Migrations

To check the status of migrations, run:
```shell
flyway -url=jdbc:postgresql://<host>:5432/postgres \
  -user=postgres \
  -password=<password> \
  -locations=filesystem:./console/db/deploy \
  info
```

Output example:
```
Flyway OSS Edition 10.13.0 by Redgate

See release notes here: https://rd.gt/416ObMi

Database: jdbc:postgresql://<host>:5432/postgres (PostgreSQL 15.1)
Schema version: 2.0.0

+-----------+---------+----------------------+------+---------------------+---------+----------+
| Category  | Version | Description          | Type | Installed On        | State   | Undoable |
+-----------+---------+----------------------+------+---------------------+---------+----------+
| Versioned | 2.0.0   | initial scheme setup | SQL  | 2024-05-17 10:08:34 | Success | No       |
+-----------+---------+----------------------+------+---------------------+---------+----------+
```

### Database Schema

#### Tables:
- `cloud_providers`
  - Table containing cloud providers information
- `cloud_regions`
  - Table containing cloud regions information for various cloud providers
- `cloud_instances`
  - Table containing cloud instances information (including the approximate price) for various cloud providers
- `cloud_volumes`
  - Table containing cloud volume information (including the approximate price) for various cloud providers
- `cloud_images`
  - Table containing cloud images information for various cloud providers
    - Note: For all cloud providers except AWS, the image is the same for all regions. For AWS, the image must be specified for each specific region.
- `secrets`
  - Table containing secrets for accessing cloud providers and servers
    - Note: The data is encrypted using the pgcrypto extension and a symmetric key. This symmetric key is generated at the application level and is unique for each installation.
- `projects`
  - Table containing information about projects
    - Default: 'default'
- `environments`
  - Table containing information about environments
    - Default: 'production', 'staging', 'test', 'dev', 'benchmarking'
- `clusters`
  - Table containing information about Postgres clusters
- `servers`
  - Table containing information about servers within a Postgres cluster
- `extensions`
  - The table stores information about Postgres extensions, including name, description, supported Postgres version range, and whether the extension is a contrib module or third-party.
  - 'postgres_min_version' and 'postgres_max_version' define the range of Postgres versions supported by extensions. If the postgres_max_version is NULL, it is assumed that the extension is still supported by new versions of Postgres.

#### Functions:
- `update_server_count`
  - Function to update the server_count column in the clusters table.
    - Note: This function calculates the number of servers associated with a specific cluster and updates the server_count accordingly. The trigger `update_server_count_trigger` is automatically executed whenever there are INSERT, UPDATE, or DELETE operations on the servers table. This ensures that the server_count in the clusters table is always accurate and up-to-date.
- `add_secret`
  - Function to add a secret.
    - Usage examples:
      - `SELECT add_secret('ssh_key', '<NAME>', '{"private_key": "<CONTENT>"}', 'my_encryption_key');`
      - `SELECT add_secret('password', '<NAME>', '{"username": "<CONTENT>", "password": "<CONTENT>"}', 'my_encryption_key');`
      - `SELECT add_secret('cloud_secret', 'AWS', '{"AWS_ACCESS_KEY_ID": "<CONTENT>", "AWS_SECRET_ACCESS_KEY": "<CONTENT>"}', 'my_encryption_key');`
- `get_secret`
  - Function to get a secret value in JSON format.
    - Usage example: `SELECT get_secret(1, 'my_encryption_key');`
- `get_extensions`
  - Function to get a list of available extensions in JSON format. All or 'contrib'/'third_party' only (optional).
    - Usage examples:
      - `SELECT get_extensions(16);`
      - `SELECT get_extensions(16, 'contrib');`
      - `SELECT get_extensions(16, 'third_party');`
