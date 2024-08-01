package project

import (
	"github.com/go-openapi/runtime/middleware"
	"postgesql-cluster-console/internal/controllers"
	"postgesql-cluster-console/internal/convert"
	"postgesql-cluster-console/internal/storage"
	"postgesql-cluster-console/models"
	"postgesql-cluster-console/restapi/operations/project"
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
