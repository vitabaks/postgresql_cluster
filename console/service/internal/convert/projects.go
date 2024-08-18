package convert

import (
	"postgresql-cluster-console/internal/storage"
	"postgresql-cluster-console/models"

	"github.com/go-openapi/strfmt"
)

func ProjectToSwagger(prj *storage.Project) *models.ResponseProject {
	return &models.ResponseProject{
		CreatedAt:   strfmt.DateTime(prj.CreatedAt),
		Description: prj.Description,
		ID:          prj.ID,
		Name:        prj.Name,
		UpdatedAt: func() *strfmt.DateTime {
			if prj.UpdatedAt == nil {
				return nil
			}
			updated := strfmt.DateTime(*prj.UpdatedAt)

			return &updated
		}(),
	}
}

func ProjectsToSwagger(projects []storage.Project) []*models.ResponseProject {
	resp := make([]*models.ResponseProject, 0, len(projects))
	for _, prj := range projects {
		resp = append(resp, ProjectToSwagger(&prj))
	}

	return resp
}
