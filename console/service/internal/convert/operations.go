package convert

import (
	"postgresql-cluster-console/internal/storage"
	"postgresql-cluster-console/models"

	"github.com/go-openapi/strfmt"
)

func OperationViewToSwagger(op *storage.OperationView) *models.ResponseOperation {
	return &models.ResponseOperation{
		ClusterName: op.Cluster,
		Environment: op.Environment,
		Finished: func() *strfmt.DateTime {
			if op.Finished == nil {
				return nil
			}
			finished := strfmt.DateTime(*op.Finished)

			return &finished
		}(),
		ID:      op.ID,
		Started: strfmt.DateTime(op.Started),
		Status:  op.Status,
		Type:    op.Type,
	}
}

func OperationsViewToSwagger(ops []storage.OperationView) []*models.ResponseOperation {
	resp := make([]*models.ResponseOperation, 0, len(ops))
	for _, op := range ops {
		resp = append(resp, OperationViewToSwagger(&op))
	}

	return resp
}
