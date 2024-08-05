package convert

import (
	"postgresql-cluster-console/internal/storage"
	"postgresql-cluster-console/models"
)

func DbExtensionToSwagger(ext *storage.Extension) *models.ResponseDatabaseExtension {
	return &models.ResponseDatabaseExtension{
		Contrib:            ext.Contrib,
		Description:        ext.Description,
		Image:              ext.Image,
		Name:               ext.Name,
		PostgresMaxVersion: ext.PostgresMaxVersion,
		PostgresMinVersion: ext.PostgresMinVersion,
		URL:                ext.Url,
	}
}

func DbExtensionsToSwagger(exts []storage.Extension) []*models.ResponseDatabaseExtension {
	resp := make([]*models.ResponseDatabaseExtension, 0, len(exts))
	for _, ext := range exts {
		resp = append(resp, DbExtensionToSwagger(&ext))
	}

	return resp
}
