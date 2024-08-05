package cluster

import (
	"context"
	"postgresql-cluster-console/internal/controllers"
	"postgresql-cluster-console/internal/convert"
	"postgresql-cluster-console/internal/storage"
	"postgresql-cluster-console/models"
	"postgresql-cluster-console/restapi/operations/cluster"

	"github.com/go-openapi/runtime/middleware"
	"github.com/rs/zerolog"
)

type getClusterHandler struct {
	db  storage.IStorage
	log zerolog.Logger
}

func NewGetClusterHandler(db storage.IStorage, log zerolog.Logger) cluster.GetClustersIDHandler {
	return &getClusterHandler{
		db:  db,
		log: log,
	}
}

func (h *getClusterHandler) Handle(param cluster.GetClustersIDParams) middleware.Responder {
	cl, err := h.db.GetCluster(param.HTTPRequest.Context(), param.ID)
	if err != nil {
		return cluster.NewGetClustersIDBadRequest().WithPayload(controllers.MakeErrorPayload(err, controllers.BaseError))
	}

	resp, err := getClusterInfo(param.HTTPRequest.Context(), h.db, cl)
	if err != nil {
		return cluster.NewGetClustersIDBadRequest().WithPayload(controllers.MakeErrorPayload(err, controllers.BaseError))
	}

	return cluster.NewGetClustersIDOK().WithPayload(resp)
}

func getClusterInfo(ctx context.Context, db storage.IStorage, cl *storage.Cluster) (*models.ClusterInfo, error) {
	project, err := db.GetProject(ctx, cl.ProjectID)
	if err != nil {
		return nil, err
	}

	environment, err := db.GetEnvironment(ctx, cl.EnvironmentID)
	if err != nil {
		return nil, err
	}

	servers, err := db.GetClusterServers(ctx, cl.ID)
	if err != nil {
		return nil, err
	}

	return convert.ClusterToSwagger(cl, servers, environment.Name, project.Name), nil
}
