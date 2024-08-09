package project

import (
	"fmt"
	"postgresql-cluster-console/internal/controllers"
	"postgresql-cluster-console/internal/convert"
	"postgresql-cluster-console/internal/storage"
	"postgresql-cluster-console/pkg/tracer"
	"postgresql-cluster-console/restapi/operations/project"

	"github.com/go-openapi/runtime/middleware"
	"github.com/rs/zerolog"
)

type postProjectHandler struct {
	db  storage.IStorage
	log zerolog.Logger
}

func NewPostProjectHandler(db storage.IStorage, log zerolog.Logger) project.PostProjectsHandler {
	return &postProjectHandler{
		db:  db,
		log: log,
	}
}

func (h *postProjectHandler) Handle(param project.PostProjectsParams) middleware.Responder {
	cid := param.HTTPRequest.Context().Value(tracer.CtxCidKey{}).(string)
	localLog := h.log.With().Str("cid", cid).Logger()
	checkProject, err := h.db.GetProjectByName(param.HTTPRequest.Context(), param.Body.Name)
	if err != nil {
		localLog.Warn().Err(err).Msg("failed to check project name exists")
	} else if checkProject != nil {
		return project.NewPostProjectsBadRequest().WithPayload(controllers.MakeErrorPayload(fmt.Errorf("The project %q named already exists", param.Body.Name), controllers.BaseError))
	}

	createdProject, err := h.db.CreateProject(param.HTTPRequest.Context(), param.Body.Name, param.Body.Description)
	if err != nil {
		return project.NewPostProjectsBadRequest().WithPayload(controllers.MakeErrorPayload(err, controllers.BaseError))
	}

	return project.NewPostProjectsOK().WithPayload(convert.ProjectToSwagger(createdProject))
}
