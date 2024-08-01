package operation

import (
	"github.com/go-openapi/runtime/middleware"
	"postgesql-cluster-console/internal/controllers"
	"postgesql-cluster-console/internal/storage"
	"postgesql-cluster-console/restapi/operations/operation"
)

type getOperationLogHandler struct {
	db storage.IStorage
}

func NewGetOperationLogHandler(db storage.IStorage) operation.GetOperationsIDLogHandler {
	return &getOperationLogHandler{
		db: db,
	}
}

func (h *getOperationLogHandler) Handle(param operation.GetOperationsIDLogParams) middleware.Responder {
	op, err := h.db.GetOperation(param.HTTPRequest.Context(), param.ID)
	if err != nil {
		return operation.NewGetOperationsIDLogBadRequest().WithPayload(controllers.MakeErrorPayload(err, controllers.BaseError))
	}

	var logMessage string
	if op.Log != nil {
		logMessage = *op.Log
	}

	return operation.NewGetOperationsIDLogOK().WithPayload(logMessage).WithContentType("plain/text").WithXLogCompleted(func() bool {
		return op.Status != storage.OperationStatusInProgress
	}())
}
