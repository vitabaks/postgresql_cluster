#### Примеры (варианты) реализации архитектуры высокой доступности:

##### Высокодоступный кластер, на базе Patroni (на чистом RAFT) и DNSCP (балансировка с HAProxy опционально):  
![PGSQLCluster](https://github.com/IlgizMamyshev/pgsql_cluster/blob/master/doc/PGSQLClusterPatroniOnPureRAFT.png)

##### Высокодоступный кластер, на базе Patroni, etcd и DNSCP (балансировка с HAProxy опционально):  
![PGSQLCluster](https://github.com/IlgizMamyshev/pgsql_cluster/blob/master/doc/PGSQLClusterTypeA.png)

##### Высокодоступный геораспределенный кластер, на базе Patroni, etcd и DNSCP (балансировка с HAProxy опционально):
![PGSQLCluster](https://github.com/IlgizMamyshev/pgsql_cluster/blob/master/doc/PGSQLCluster_Geo.png)
