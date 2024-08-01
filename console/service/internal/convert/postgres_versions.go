package convert

import (
	"github.com/go-openapi/strfmt"
	"postgesql-cluster-console/internal/storage"
	"postgesql-cluster-console/models"
)

func PostgresVersion(pv *storage.PostgresVersion) *models.ResponsePostgresVersion {
	return &models.ResponsePostgresVersion{
		EndOfLife:    strfmt.Date(pv.EndOfLife),
		MajorVersion: pv.MajorVersion,
		ReleaseDate:  strfmt.Date(pv.ReleaseDate),
	}
}

func PostgresVersions(pvs []storage.PostgresVersion) []*models.ResponsePostgresVersion {
	resp := make([]*models.ResponsePostgresVersion, 0, len(pvs))
	for _, pv := range pvs {
		resp = append(resp, PostgresVersion(&pv))
	}

	return resp
}
