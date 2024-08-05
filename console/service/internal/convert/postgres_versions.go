package convert

import (
	"postgresql-cluster-console/internal/storage"
	"postgresql-cluster-console/models"

	"github.com/go-openapi/strfmt"
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
