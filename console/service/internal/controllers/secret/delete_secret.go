package secret

import (
	"postgresql-cluster-console/internal/controllers"
	"postgresql-cluster-console/internal/storage"
	"postgresql-cluster-console/restapi/operations/secret"

	"github.com/go-openapi/runtime/middleware"
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
