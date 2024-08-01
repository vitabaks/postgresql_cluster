package secret

import (
	"github.com/go-openapi/runtime/middleware"
	"postgesql-cluster-console/internal/controllers"
	"postgesql-cluster-console/internal/storage"
	"postgesql-cluster-console/restapi/operations/secret"
)

type deleteSecretHandler struct {
	db storage.IStorage
}

func NewDeleteSecretHandler(db storage.IStorage) secret.DeleteSecretsIDHandler {
	return &deleteSecretHandler{
		db: db,
	}
}

func (h *deleteSecretHandler) Handle(param secret.DeleteSecretsIDParams) middleware.Responder {
	err := h.db.DeleteSecret(param.HTTPRequest.Context(), param.ID)
	if err != nil {
		return secret.NewDeleteSecretsIDBadRequest().WithPayload(controllers.MakeErrorPayload(err, controllers.BaseError))
	}

	return secret.NewDeleteSecretsIDNoContent()
}
