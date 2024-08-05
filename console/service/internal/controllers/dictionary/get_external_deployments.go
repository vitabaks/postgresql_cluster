package dictionary

import (
	"postgresql-cluster-console/internal/controllers"
	"postgresql-cluster-console/internal/convert"
	"postgresql-cluster-console/internal/storage"
	"postgresql-cluster-console/models"
	"postgresql-cluster-console/restapi/operations/dictionary"

	"github.com/go-openapi/runtime/middleware"
)

type getExternalDeploymentsHandler struct {
	db storage.IStorage
}

func NewGetExternalDeploymentsHandler(db storage.IStorage) dictionary.GetExternalDeploymentsHandler {
	return &getExternalDeploymentsHandler{
		db: db,
	}
}

func (h *getExternalDeploymentsHandler) Handle(param dictionary.GetExternalDeploymentsParams) middleware.Responder {
	cloudProviders, metaPagination, err := h.db.GetCloudProviders(param.HTTPRequest.Context(), param.Limit, param.Offset)
	if err != nil {
		return dictionary.NewGetExternalDeploymentsBadRequest().WithPayload(controllers.MakeErrorPayload(err, controllers.BaseError))
	}

	resp := &models.ResponseDeploymentsInfo{
		Data: make([]*models.ResponseDeploymentInfo, 0, len(cloudProviders)),
		Meta: &models.MetaPagination{
			Count:  &metaPagination.Count,
			Limit:  &metaPagination.Limit,
			Offset: &metaPagination.Offset,
		},
	}
	for _, cloudProvider := range cloudProviders {
		cloudProviderInfo, err := h.db.GetCloudProviderInfo(param.HTTPRequest.Context(), cloudProvider.Code)
		if err != nil {
			return dictionary.NewGetDatabaseExtensionsBadRequest().WithPayload(controllers.MakeErrorPayload(err, controllers.BaseError))
		}

		resp.Data = append(resp.Data, convert.ProviderInfoToSwagger(cloudProviderInfo, cloudProvider.Description, cloudProvider.ProviderImage))
	}

	return dictionary.NewGetExternalDeploymentsOK().WithPayload(resp)
}
