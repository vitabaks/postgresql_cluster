package project

import (
	"postgresql-cluster-console/internal/controllers"
	"postgresql-cluster-console/internal/convert"
	"postgresql-cluster-console/internal/storage"
	"postgresql-cluster-console/restapi/operations/project"

	"github.com/go-openapi/runtime/middleware"
)

type patchProjectHandler struct {
	db storage.IStorage
}

func NewPatchProjectHandler(db storage.IStorage) project.PatchProjectsIDHandler {
	return &patchProjectHandler{
		db: db,
	}
}

func (h *patchProjectHandler) Handle(param project.PatchProjectsIDParams) middleware.Responder {
	updatedProject, err := h.db.UpdateProject(param.HTTPRequest.Context(), param.ID, param.Body.Name, param.Body.Description)
	if err != nil {
		return project.NewPatchProjectsIDBadRequest().WithPayload(controllers.MakeErrorPayload(err, controllers.BaseError))
	}

	return project.NewPatchProjectsIDOK().WithPayload(convert.ProjectToSwagger(updatedProject))
}
