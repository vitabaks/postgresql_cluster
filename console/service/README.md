# postgesql-cluster-console server

Server side for postgresql-cluster-console.
REST service that implements API for WEB integration.
Project is written on `golang` and used [swagger](https://github.com/go-swagger/go-swagger) for server-side auto generation.
Server is received requests from WEB for creation and manage clusters.
Under the hood server uses docker for running ansible scripts with cluster deploy logic.

## Build
Swagger specification is used for creating server REST API. First of all you need to install swagger tool to build auto generated go-files.
```
export dir=$$(mktemp -d)
git clone https://github.com/go-swagger/go-swagger "$$dir"
cd "$$dir"
go install ./cmd/swagger
```
Then you need to generate server side files:
```
swagger generate server --name DbConsole --spec api/swagger.yaml --principal interface{} --exclude-main
```

After that you can build server with following command:
```
go build -o pg-console main.go
```

The project also contains makefile with all commands. So you can just do next steps:
```
make swagger_install
make swagger
make build
```

## Configuration
Server is configured via the environment. The following environment variables can be used:
```
KEY                                   TYPE                DEFAULT                              REQUIRED    DESCRIPTION
PG_CONSOLE_LOGGER_LEVEL               String              DEBUG                                            Log level. Accepted values: [TRACE, DEBUG, INFO, WARN, ERROR, FATAL, PANIC]
PG_CONSOLE_HTTP_HOST                  String              0.0.0.0                                          Accepted host for connection. '0.0.0.0' for all hosts
PG_CONSOLE_HTTP_PORT                  Integer             8080                                             Listening port
PG_CONSOLE_HTTP_WRITETIMEOUT          Duration            10s                                              Maximum duration before timing out write of the response
PG_CONSOLE_HTTP_READTIMEOUT           Duration            10s                                              Maximum duration before timing out read of the request
PG_CONSOLE_HTTPS_ISUSED               True or False       false                                            Flag for turn on/off https
PG_CONSOLE_HTTPS_HOST                 String              0.0.0.0                                          Accepted host for connection. '0.0.0.0' for all hosts
PG_CONSOLE_HTTPS_PORT                 Integer             8081                                             Listening port
PG_CONSOLE_HTTPS_CACERT               String              /etc/pg_console/cacert.pem                       The certificate to use for secure connections
PG_CONSOLE_HTTPS_SERVERCERT           String              /etc/pg_console/server-cert.pem                  The certificate authority file to be used with mutual tls auth
PG_CONSOLE_HTTPS_SERVERKEY            String              /etc/pg_console/server-key.pem                   The private key to use for secure connections
PG_CONSOLE_AUTHORIZATION_TOKEN        String              auth_token                                       Authorization token for REST API
PG_CONSOLE_DB_HOST                    String              localhost                                        Database host
PG_CONSOLE_DB_PORT                    Unsigned Integer    5432                                             Database port
PG_CONSOLE_DB_DBNAME                  String              postgres                                         Database name
PG_CONSOLE_DB_USER                    String              postgres                                         Database user name
PG_CONSOLE_DB_PASSWORD                String              postgres-pass                                    Database user password
PG_CONSOLE_DB_MAXCONNS                Integer             10                                               MaxConns is the maximum size of the pool
PG_CONSOLE_DB_MAXCONNLIFETIME         Duration            60s                                              MaxConnLifetime is the duration since creation after which a connection will be automatically closed
PG_CONSOLE_DB_MAXCONNIDLETIME         Duration            60s                                              MaxConnIdleTime is the duration after which an idle connection will be automatically closed by the health check
PG_CONSOLE_DB_MIGRATIONDIR            String              /etc/db/migrations                               Path to directory with migration scripts
PG_CONSOLE_ENCRYPTIONKEY              String              super_secret                                     Encryption key for secret storage
PG_CONSOLE_DOCKER_HOST                String              unix:///var/run/docker.sock                      Docker host
PG_CONSOLE_DOCKER_LOGDIR              String              /tmp/ansible                                     Directory inside docker container for ansible json log
PG_CONSOLE_DOCKER_IMAGE               String              vitabaks/postgresql_cluster:cloud                Docker image for postgresql_cluster
PG_CONSOLE_LOGWATCHER_RUNEVERY        Duration            1m                                               LogWatcher run interval
PG_CONSOLE_LOGWATCHER_ANALYZEPAST     Duration            48h                                              LogWatcher gets operations to analyze which created_at > now() - AnalyzePast
PG_CONSOLE_CLUSTERWATCHER_RUNEVERY    Duration            1m                                               ClusterWatcher run interval
PG_CONSOLE_CLUSTERWATCHER_POOLSIZE    Integer             4                                                Amount of async request from ClusterWatcher
```

## Project architecture
```
|-api - swagger specification
|-internal - folder with all internal logic
| |-controllers - REST fuctions and basic logic for handlers
| | |-cluster - REST API for clusters objects
| | |-dictionary - REST API for dictionaries objects
| | |-operation - REST API for operations objects
| | |-project - REST API for projects objects
| | |-secret - REST API for secrets objects
| |-convert - functions for convert DB model for REST model
| |-db - base DB functions
| |-service - common logic for aggrigation all server logic
| |-storage - DB logic
| |-watcher - async watchers
| | |-log_collector.go - collecting logs from running docker container
| | |-log_watcher.go - JSON container log parser
| | |-server_watcher.go - collecting servers statuses  
| |-xdocker - basic logic for docker
|-middleware - common REST middlewares for server
|-migrations - DB migrations logic   
|-pkg - folder with common logic
| |-patroni - client for patroni integration
| |-tracer - base structure for tracing
|-*models - auto-generated files with REST models
|-*restapi - auto-generated files with REST server
|-main.go - entry point
```

## Secrets
Server handles different kind of secrets, such as:
* cloud secrets, that uses for cloud connections
* ssh keys and passwords for connection to owm machine servers
* database secrets

Be attention to use `TRACE` level of logging. With `TRACE` level some kind of secrets can be present in logs.