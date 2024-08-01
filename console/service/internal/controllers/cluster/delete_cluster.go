package cluster

import (
	"github.com/go-openapi/runtime/middleware"
	"postgesql-cluster-console/internal/controllers"
	"postgesql-cluster-console/internal/storage"
	"postgesql-cluster-console/restapi/operations/cluster"
)

type deleteClusterHandler struct {
	db storage.IStorage
}

func NewDeleteClusterHandler(db storage.IStorage) cluster.DeleteClustersIDHandler {
	return &deleteClusterHandler{
		db: db,
	}
}

func (h *deleteClusterHandler) Handle(param cluster.DeleteClustersIDParams) middleware.Responder {
	err := h.db.DeleteClusterSoft(param.HTTPRequest.Context(), param.ID)
	if err != nil {
		return cluster.NewDeleteClustersIDBadRequest().WithPayload(controllers.MakeErrorPayload(err, controllers.BaseError))
	}

	return cluster.NewDeleteClustersIDNoContent()
}
