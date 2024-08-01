package storage

import (
	"context"
	"time"
)

type IStorage interface {
	GetCloudProviders(ctx context.Context, limit, offset *int64) ([]CloudProvider, *MetaPagination, error)
	GetCloudProviderInfo(ctx context.Context, providerCode string) (*CloudProviderInfo, error)
	GetExtensions(ctx context.Context, req *GetExtensionsReq) ([]Extension, *MetaPagination, error)
	GetPostgresVersions(ctx context.Context) ([]PostgresVersion, error)

	// environment
	GetEnvironments(ctx context.Context, limit, offset *int64) ([]Environment, *MetaPagination, error)
	GetEnvironment(ctx context.Context, id int64) (*Environment, error)
	GetEnvironmentByName(ctx context.Context, name string) (*Environment, error)
	CreateEnvironment(ctx context.Context, req *AddEnvironmentReq) (*Environment, error)
	DeleteEnvironment(ctx context.Context, id int64) error
	CheckEnvironmentIsUsed(ctx context.Context, id int64) (bool, error)

	// setting
	CreateSetting(ctx context.Context, name string, value interface{}) (*Setting, error)
	GetSettings(ctx context.Context, req *GetSettingsReq) ([]Setting, *MetaPagination, error)
	GetSettingByName(ctx context.Context, name string) (*Setting, error)
	UpdateSetting(ctx context.Context, name string, value interface{}) (*Setting, error)

	// project
	CreateProject(ctx context.Context, name, description string) (*Project, error)
	GetProjects(ctx context.Context, limit, offset *int64) ([]Project, *MetaPagination, error)
	GetProject(ctx context.Context, id int64) (*Project, error)
	GetProjectByName(ctx context.Context, name string) (*Project, error)
	DeleteProject(ctx context.Context, id int64) error
	UpdateProject(ctx context.Context, id int64, name, description *string) (*Project, error)

	// secrets
	GetSecrets(ctx context.Context, req *GetSecretsReq) ([]SecretView, *MetaPagination, error)
	GetSecret(ctx context.Context, id int64) (*SecretView, error)
	GetSecretByName(ctx context.Context, name string) (*SecretView, error)
	CreateSecret(ctx context.Context, req *AddSecretReq) (*SecretView, error)
	DeleteSecret(ctx context.Context, id int64) error
	GetSecretVal(ctx context.Context, id int64, secretKey string) ([]byte, error)

	// cluster
	CreateCluster(ctx context.Context, req *CreateClusterReq) (*Cluster, error)
	GetCluster(ctx context.Context, id int64) (*Cluster, error)
	GetClusters(ctx context.Context, req *GetClustersReq) ([]Cluster, *MetaPagination, error)
	GetDefaultClusterName(ctx context.Context) (string, error)
	DeleteCluster(ctx context.Context, id int64) error
	DeleteClusterSoft(ctx context.Context, id int64) error
	DeleteServer(ctx context.Context, id int64) error
	GetClusterByName(ctx context.Context, name string) (*Cluster, error)
	UpdateCluster(ctx context.Context, req *UpdateClusterReq) (*Cluster, error)

	// operation
	CreateOperation(ctx context.Context, req *CreateOperationReq) (*Operation, error)
	GetOperations(ctx context.Context, req *GetOperationsReq) ([]OperationView, *MetaPagination, error)
	GetOperation(ctx context.Context, id int64) (*Operation, error)
	UpdateOperation(ctx context.Context, req *UpdateOperationReq) (*Operation, error)
	GetInProgressOperations(ctx context.Context, from time.Time) ([]Operation, error)

	// server
	CreateServer(ctx context.Context, req *CreateServerReq) (*Server, error)
	GetServer(ctx context.Context, id int64) (*Server, error)
	GetClusterServers(ctx context.Context, clusterID int64) ([]Server, error)
	UpdateServer(ctx context.Context, req *UpdateServerReq) (*Server, error)
	ResetServer(ctx context.Context, clusterID int64, ipAddress string) (*Server, error)
}
