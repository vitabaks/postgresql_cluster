package setting

import (
	"postgresql-cluster-console/internal/controllers"
	"postgresql-cluster-console/internal/convert"
	"postgresql-cluster-console/internal/storage"
	"postgresql-cluster-console/models"
	"postgresql-cluster-console/restapi/operations/setting"

	"github.com/go-openapi/runtime/middleware"
)

type getSettingsHandler struct {
	db storage.IStorage
}

func NewGetSettingsHandler(db storage.IStorage) setting.GetSettingsHandler {
	return &getSettingsHandler{
		db: db,
	}
}

func (h *getSettingsHandler) Handle(param setting.GetSettingsParams) middleware.Responder {
	settings, meta, err := h.db.GetSettings(param.HTTPRequest.Context(), &storage.GetSettingsReq{
		Name:   param.Name,
		Limit:  param.Limit,
		Offset: param.Offset,
	})
	if err != nil {
		return setting.NewGetSettingsBadRequest().WithPayload(controllers.MakeErrorPayload(err, controllers.BaseError))
	}

	return setting.NewGetSettingsOK().WithPayload(&models.ResponseSettings{
		Data: convert.SettingsToSwagger(settings),
		Mete: &models.MetaPagination{
			Count:  &meta.Count,
			Limit:  &meta.Limit,
			Offset: &meta.Offset,
		},
	})
}
