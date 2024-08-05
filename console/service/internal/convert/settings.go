package convert

import (
	"postgresql-cluster-console/internal/storage"
	"postgresql-cluster-console/models"

	"github.com/go-openapi/strfmt"
)

func SettingToSwagger(s *storage.Setting) *models.ResponseSetting {
	return &models.ResponseSetting{
		CreatedAt: strfmt.DateTime(s.CreatedAt),
		ID:        s.ID,
		Name:      s.Name,
		UpdatedAt: func() *strfmt.DateTime {
			if s.UpdatedAt == nil {
				return nil
			}
			updated := strfmt.DateTime(*s.UpdatedAt)

			return &updated
		}(),
		Value: s.Value,
	}
}

func SettingsToSwagger(settings []storage.Setting) []*models.ResponseSetting {
	resp := make([]*models.ResponseSetting, 0, len(settings))
	for _, s := range settings {
		resp = append(resp, SettingToSwagger(&s))
	}

	return resp
}
