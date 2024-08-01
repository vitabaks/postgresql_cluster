package environment

import (
	"github.com/go-openapi/runtime/middleware"
	"postgesql-cluster-console/internal/controllers"
	"postgesql-cluster-console/internal/convert"
	"postgesql-cluster-console/internal/storage"
	"postgesql-cluster-console/models"
	"postgesql-cluster-console/restapi/operations/environment"
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
