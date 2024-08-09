package secret

import (
	"encoding/json"
	"fmt"
	"postgresql-cluster-console/internal/configuration"
	"postgresql-cluster-console/internal/controllers"
	"postgresql-cluster-console/internal/convert"
	"postgresql-cluster-console/internal/storage"
	"postgresql-cluster-console/models"
	"postgresql-cluster-console/pkg/tracer"
	"postgresql-cluster-console/restapi/operations/secret"

	"github.com/go-openapi/runtime/middleware"
	"github.com/rs/zerolog"
)

type postSecretHandler struct {
	db  storage.IStorage
	log zerolog.Logger
	cfg *configuration.Config
}

func NewPostSecretHandler(db storage.IStorage, log zerolog.Logger, cfg *configuration.Config) secret.PostSecretsHandler {
	return &postSecretHandler{
		db:  db,
		log: log,
		cfg: cfg,
	}
}

func (h *postSecretHandler) Handle(param secret.PostSecretsParams) middleware.Responder {
	cid := param.HTTPRequest.Context().Value(tracer.CtxCidKey{}).(string)
	localLog := h.log.With().Str("cid", cid).Logger()
	checkSecret, err := h.db.GetSecretByName(param.HTTPRequest.Context(), param.Body.Name)
	if err != nil {
		localLog.Warn().Err(err).Msg("failed to check secret name exists")
	} else if checkSecret != nil {
		return secret.NewPostSecretsBadRequest().WithPayload(controllers.MakeErrorPayload(fmt.Errorf("The secret named %q already exists", param.Body.Name), controllers.BaseError))
	}

	var (
		value []byte
	)
	switch param.Body.Type {
	case models.SecretTypeAws:
		value, err = json.Marshal(param.Body.Value.Aws)
	case models.SecretTypeGcp:
		value, err = json.Marshal(param.Body.Value.Gcp)
	case models.SecretTypeHetzner:
		value, err = json.Marshal(param.Body.Value.Hetzner)
	case models.SecretTypeSSHKey:
		value, err = json.Marshal(param.Body.Value.SSHKey)
	case models.SecretTypeDigitalocean:
		value, err = json.Marshal(param.Body.Value.Digitalocean)
	case models.SecretTypeAzure:
		value, err = json.Marshal(param.Body.Value.Azure)
	case models.SecretTypePassword:
		value, err = json.Marshal(param.Body.Value.Password)
	}
	if err != nil {
		return secret.NewPostSecretsBadRequest().WithPayload(controllers.MakeErrorPayload(err, controllers.BaseError))
	}

	createdSecret, err := h.db.CreateSecret(param.HTTPRequest.Context(), &storage.AddSecretReq{
		ProjectID: param.Body.ProjectID,
		Type:      string(param.Body.Type),
		Name:      param.Body.Name,
		Value:     value,
		SecretKey: h.cfg.EncryptionKey,
	})
	if err != nil {
		return secret.NewPostSecretsBadRequest().WithPayload(controllers.MakeErrorPayload(err, controllers.BaseError))
	}

	return secret.NewPostSecretsOK().WithPayload(convert.SecretViewToSwagger(createdSecret))
}
