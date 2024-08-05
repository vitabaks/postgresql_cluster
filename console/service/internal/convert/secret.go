package convert

import (
	"postgresql-cluster-console/internal/storage"
	"postgresql-cluster-console/models"

	"github.com/go-openapi/strfmt"
)

func SecretViewToSwagger(secret *storage.SecretView) *models.ResponseSecretInfo {
	return &models.ResponseSecretInfo{
		CreatedAt: strfmt.DateTime(secret.CreatedAt),
		ID:        secret.ID,
		IsUsed:    secret.IsUsed,
		Name:      secret.Name,
		ProjectID: secret.ProjectID,
		Type:      models.SecretType(secret.Type),
		UpdatedAt: func() *strfmt.DateTime {
			if secret.UpdatedAt == nil {
				return nil
			}
			updated := strfmt.DateTime(*secret.UpdatedAt)

			return &updated
		}(),
		UsedByClusters: secret.UsedByClusters,
	}
}

func SecretsViewToSwagger(secrets []storage.SecretView) []*models.ResponseSecretInfo {
	resp := make([]*models.ResponseSecretInfo, 0, len(secrets))
	for _, sec := range secrets {
		resp = append(resp, SecretViewToSwagger(&sec))
	}

	return resp
}
