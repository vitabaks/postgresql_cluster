package cluster

import (
	"postgresql-cluster-console/internal/controllers"
	"postgresql-cluster-console/internal/storage"
	"postgresql-cluster-console/internal/watcher"
	"postgresql-cluster-console/restapi/operations/cluster"

	"github.com/go-openapi/runtime/middleware"
	"github.com/rs/zerolog"
)

type postClusterRefreshHandler struct {
	db             storage.IStorage
	log            zerolog.Logger
	clusterWatcher watcher.ClusterWatcher
}

func NewPostClusterRefreshHandler(db storage.IStorage, log zerolog.Logger, clusterWatcher watcher.ClusterWatcher) cluster.PostClustersIDRefreshHandler {
	return &postClusterRefreshHandler{
		db:             db,
		log:            log,
		clusterWatcher: clusterWatcher,
	}
}

func (h *postClusterRefreshHandler) Handle(param cluster.PostClustersIDRefreshParams) middleware.Responder {
	cl, err := h.db.GetCluster(param.HTTPRequest.Context(), param.ID)
	if err != nil {
		return cluster.NewPostClustersIDRefreshBadRequest().WithPayload(controllers.MakeErrorPayload(err, controllers.BaseError))
	}

	h.clusterWatcher.HandleCluster(param.HTTPRequest.Context(), cl)

	resp, err := getClusterInfo(param.HTTPRequest.Context(), h.db, cl)
	if err != nil {
		return cluster.NewPostClustersIDRefreshBadRequest().WithPayload(controllers.MakeErrorPayload(err, controllers.BaseError))
	}

	return cluster.NewPostClustersIDRefreshOK().WithPayload(resp)
}
