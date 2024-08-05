package environment

import (
	"postgresql-cluster-console/internal/controllers"
	"postgresql-cluster-console/internal/convert"
	"postgresql-cluster-console/internal/storage"
	"postgresql-cluster-console/models"
	"postgresql-cluster-console/restapi/operations/environment"

	"github.com/go-openapi/runtime/middleware"
)

type getEnvironmentsHandler struct {
	db storage.IStorage
}

func NewGetEnvironmentsHandler(db storage.IStorage) environment.GetEnvironmentsHandler {
	return &getEnvironmentsHandler{
		db: db,
	}
}

func (h *getEnvironmentsHandler) Handle(param environment.GetEnvironmentsParams) middleware.Responder {
	environments, meta, err := h.db.GetEnvironments(param.HTTPRequest.Context(), param.Limit, param.Offset)
	if err != nil {
		return environment.NewGetEnvironmentsBadRequest().WithPayload(controllers.MakeErrorPayload(err, controllers.BaseError))
	}

	return environment.NewGetEnvironmentsOK().WithPayload(&models.ResponseEnvironmentsList{
		Data: convert.EnvironmentsToSwagger(environments),
		Meta: &models.MetaPagination{
			Count:  &meta.Count,
			Limit:  &meta.Limit,
			Offset: &meta.Offset,
		},
	})
}
