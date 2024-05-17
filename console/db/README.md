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

Flyway OSS Edition 10.13.0 by Redgate

See release notes here: https://rd.gt/416ObMi

Database: jdbc:postgresql://<host>:5432/postgres (PostgreSQL 15.1)
Schema history table "public"."flyway_schema_history" does not exist yet
Successfully validated 1 migration (execution time 00:00.816s)
Creating Schema History table "public"."flyway_schema_history" ...
Current version of schema "public": << Empty Schema >>
Migrating schema "public" to version "2.0.0 - initial scheme setup"
Successfully applied 1 migration to schema "public", now at version v2.0.0 (execution time 00:17.123s)
```

### Validating Migrations

To check the status of migrations, run:
```
flyway -url=jdbc:postgresql://<host>:5432/postgres \
  -user=postgres.myrwwrwtmghpfvefarbf \
  -password=<password> \
  -locations=filesystem:./console/db/deploy \
  info

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
