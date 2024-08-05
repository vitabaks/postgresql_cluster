package project

import (
	"postgresql-cluster-console/internal/controllers"
	"postgresql-cluster-console/internal/convert"
	"postgresql-cluster-console/internal/storage"
	"postgresql-cluster-console/models"
	"postgresql-cluster-console/restapi/operations/project"

	"github.com/go-openapi/runtime/middleware"
)

type getProjectsHandler struct {
	db storage.IStorage
}

func NewGetProjectsHandler(db storage.IStorage) project.GetProjectsHandler {
	return &getProjectsHandler{
		db: db,
	}
}

func (h *getProjectsHandler) Handle(param project.GetProjectsParams) middleware.Responder {
	projects, meta, err := h.db.GetProjects(param.HTTPRequest.Context(), param.Limit, param.Offset)
	if err != nil {
		return project.NewGetProjectsBadRequest().WithPayload(controllers.MakeErrorPayload(err, controllers.BaseError))
	}

	return project.NewGetProjectsOK().WithPayload(&models.ResponseProjectsList{
		Data: convert.ProjectsToSwagger(projects),
		Meta: &models.MetaPagination{
			Count:  &meta.Count,
			Limit:  &meta.Limit,
			Offset: &meta.Offset,
		},
	})
}
