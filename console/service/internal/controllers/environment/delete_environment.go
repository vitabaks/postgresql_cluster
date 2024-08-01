package environment

import (
	"errors"
	"github.com/go-openapi/runtime/middleware"
	"github.com/rs/zerolog"
	"postgesql-cluster-console/internal/controllers"
	"postgesql-cluster-console/internal/storage"
	"postgesql-cluster-console/pkg/tracer"
	"postgesql-cluster-console/restapi/operations/environment"
)

type deleteEnvironmentsHandler struct {
	db  storage.IStorage
	log zerolog.Logger
}

func NewDeleteEnvironmentsHandler(db storage.IStorage, log zerolog.Logger) environment.DeleteEnvironmentsIDHandler {
	return &deleteEnvironmentsHandler{
		db:  db,
		log: log,
	}
}

func (h *deleteEnvironmentsHandler) Handle(param environment.DeleteEnvironmentsIDParams) middleware.Responder {
	cid := param.HTTPRequest.Context().Value(tracer.CtxCidKey{}).(string)
	localLog := h.log.With().Str("cid", cid).Logger()
	isUsed, err := h.db.CheckEnvironmentIsUsed(param.HTTPRequest.Context(), param.ID)
	if err != nil {
		localLog.Warn().Err(err).Msg("failed to check that environment is used")
	} else if isUsed {
		return environment.NewDeleteEnvironmentsIDBadRequest().WithPayload(controllers.MakeErrorPayload(errors.New("The environment is used"), controllers.BaseError))
	}
	err = h.db.DeleteEnvironment(param.HTTPRequest.Context(), param.ID)
	if err != nil {
		return environment.NewDeleteEnvironmentsIDBadRequest().WithPayload(controllers.MakeErrorPayload(err, controllers.BaseError))
	}

	return environment.NewDeleteEnvironmentsIDNoContent()
}
