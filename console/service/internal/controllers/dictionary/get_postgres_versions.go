package dictionary

import (
	"postgresql-cluster-console/internal/controllers"
	"postgresql-cluster-console/internal/convert"
	"postgresql-cluster-console/internal/storage"
	"postgresql-cluster-console/models"
	"postgresql-cluster-console/restapi/operations/dictionary"

	"github.com/go-openapi/runtime/middleware"
)

type getPostgresVersionsHandler struct {
	db storage.IStorage
}

func NewGetPostgresVersions(db storage.IStorage) dictionary.GetPostgresVersionsHandler {
	return &getPostgresVersionsHandler{
		db: db,
	}
}

func (h *getPostgresVersionsHandler) Handle(param dictionary.GetPostgresVersionsParams) middleware.Responder {
	postgresVersions, err := h.db.GetPostgresVersions(param.HTTPRequest.Context())
	if err != nil {
		return dictionary.NewGetPostgresVersionsBadRequest().WithPayload(controllers.MakeErrorPayload(err, controllers.BaseError))
	}

	return dictionary.NewGetPostgresVersionsOK().WithPayload(&models.ResponsePostgresVersions{
		Data: convert.PostgresVersions(postgresVersions),
	})
}
