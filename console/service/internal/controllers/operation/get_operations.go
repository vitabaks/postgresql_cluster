package operation

import (
	"postgresql-cluster-console/internal/controllers"
	"postgresql-cluster-console/internal/convert"
	"postgresql-cluster-console/internal/storage"
	"postgresql-cluster-console/models"
	"postgresql-cluster-console/restapi/operations/operation"
	"time"

	"github.com/go-openapi/runtime/middleware"
)

type getOperationsHandler struct {
	db storage.IStorage
}

func NewGetOperationsHandler(db storage.IStorage) operation.GetOperationsHandler {
	return &getOperationsHandler{
		db: db,
	}
}

func (h *getOperationsHandler) Handle(param operation.GetOperationsParams) middleware.Responder {
	operations, meta, err := h.db.GetOperations(param.HTTPRequest.Context(), &storage.GetOperationsReq{
		ProjectID:   param.ProjectID,
		StartedFrom: time.Time(param.StartDate),
		EndedTill:   time.Time(param.EndDate),
		ClusterName: param.ClusterName,
		Type:        param.Type,
		Status:      param.Status,
		SortBy:      param.SortBy,
		Limit:       param.Limit,
		Offset:      param.Offset,
	})
	if err != nil {
		return operation.NewGetOperationsBadRequest().WithPayload(controllers.MakeErrorPayload(err, controllers.BaseError))
	}

	return operation.NewGetOperationsOK().WithPayload(&models.ResponseOperationsList{
		Data: convert.OperationsViewToSwagger(operations),
		Meta: &models.MetaPagination{
			Count:  &meta.Count,
			Limit:  &meta.Limit,
			Offset: &meta.Offset,
		},
	})
}
