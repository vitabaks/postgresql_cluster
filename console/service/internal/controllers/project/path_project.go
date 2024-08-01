package project

import (
	"github.com/go-openapi/runtime/middleware"
	"postgesql-cluster-console/internal/controllers"
	"postgesql-cluster-console/internal/convert"
	"postgesql-cluster-console/internal/storage"
	"postgesql-cluster-console/restapi/operations/project"
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
