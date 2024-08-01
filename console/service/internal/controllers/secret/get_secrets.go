package secret

import (
	"github.com/go-openapi/runtime/middleware"
	"postgesql-cluster-console/internal/controllers"
	"postgesql-cluster-console/internal/convert"
	"postgesql-cluster-console/internal/storage"
	"postgesql-cluster-console/models"
	"postgesql-cluster-console/restapi/operations/secret"
)

type getSecretHandler struct {
	db storage.IStorage
}

func NewGetSecretHandler(db storage.IStorage) secret.GetSecretsHandler {
	return &getSecretHandler{
		db: db,
	}
}

func (h *getSecretHandler) Handle(param secret.GetSecretsParams) middleware.Responder {
	secrets, meta, err := h.db.GetSecrets(param.HTTPRequest.Context(), &storage.GetSecretsReq{
		ProjectID: param.ProjectID,
		Name:      param.Name,
		Type:      param.Type,
		SortBy:    param.SortBy,
		Limit:     param.Limit,
		Offset:    param.Offset,
	})
	if err != nil {
		return secret.NewGetSecretsBadRequest().WithPayload(controllers.MakeErrorPayload(err, controllers.BaseError))
	}

	return secret.NewGetSecretsOK().WithPayload(&models.ResponseSecretInfoList{
		Data: convert.SecretsViewToSwagger(secrets),
		Meta: &models.MetaPagination{
			Count:  &meta.Count,
			Limit:  &meta.Limit,
			Offset: &meta.Offset,
		},
	})
}
