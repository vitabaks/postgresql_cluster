package cluster

import (
	"postgresql-cluster-console/internal/controllers"
	"postgresql-cluster-console/internal/storage"
	"postgresql-cluster-console/pkg/tracer"
	"postgresql-cluster-console/restapi/operations/cluster"

	"github.com/go-openapi/runtime/middleware"
	"github.com/rs/zerolog"
)

type deleteServerHandler struct {
	db  storage.IStorage
	log zerolog.Logger
}

func NewDeleteServerHandler(db storage.IStorage, log zerolog.Logger) cluster.DeleteServersIDHandler {
	return &deleteServerHandler{
		db:  db,
		log: log,
	}
}

func (h *deleteServerHandler) Handle(param cluster.DeleteServersIDParams) middleware.Responder {
	cid := param.HTTPRequest.Context().Value(tracer.CtxCidKey{}).(string)
	localLog := h.log.With().Str("cid", cid).Logger()
	deletedServer, err := h.db.GetServer(param.HTTPRequest.Context(), param.ID)
	if err != nil {
		localLog.Warn().Err(err).Msg("failed to get server from db")
	}
	clusterID := int64(-1)
	if deletedServer != nil {
		clusterID = deletedServer.ClusterID
	}
	err = h.db.DeleteServer(param.HTTPRequest.Context(), param.ID)
	if err != nil {
		return cluster.NewDeleteServersIDBadRequest().WithPayload(controllers.MakeErrorPayload(err, controllers.BaseError))
	}

	return cluster.NewDeleteServersIDNoContent().WithXClusterID(clusterID)
}
