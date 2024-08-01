package dictionary

import (
	"github.com/go-openapi/runtime/middleware"
	"postgesql-cluster-console/internal/controllers"
	"postgesql-cluster-console/internal/convert"
	"postgesql-cluster-console/internal/storage"
	"postgesql-cluster-console/models"
	"postgesql-cluster-console/restapi/operations/dictionary"
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
