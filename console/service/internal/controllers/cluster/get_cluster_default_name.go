package cluster

import (
	"postgresql-cluster-console/internal/controllers"
	"postgresql-cluster-console/internal/storage"
	"postgresql-cluster-console/models"
	"postgresql-cluster-console/restapi/operations/cluster"

	"github.com/go-openapi/runtime/middleware"
	"github.com/rs/zerolog"
)

type getClusterDefaultNameHandler struct {
	db  storage.IStorage
	log zerolog.Logger
}

func NewGetClusterDefaultNameHandler(db storage.IStorage, log zerolog.Logger) cluster.GetClustersDefaultNameHandler {
	return &getClusterDefaultNameHandler{
		db:  db,
		log: log,
	}
}

func (h *getClusterDefaultNameHandler) Handle(param cluster.GetClustersDefaultNameParams) middleware.Responder {
	name, err := h.db.GetDefaultClusterName(param.HTTPRequest.Context())
	if err != nil {
		return cluster.NewGetClustersDefaultNameBadRequest().WithPayload(controllers.MakeErrorPayload(err, controllers.BaseError))
	}

	return cluster.NewGetClustersDefaultNameOK().WithPayload(&models.ResponseClusterDefaultName{
		Name: name,
	})
}
