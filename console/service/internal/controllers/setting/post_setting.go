package setting

import (
	"postgresql-cluster-console/internal/controllers"
	"postgresql-cluster-console/internal/convert"
	"postgresql-cluster-console/internal/storage"
	"postgresql-cluster-console/restapi/operations/setting"

	"github.com/go-openapi/runtime/middleware"
)

type postSettingHandler struct {
	db storage.IStorage
}

func NewPostSettingHandler(db storage.IStorage) setting.PostSettingsHandler {
	return &postSettingHandler{
		db: db,
	}
}

func (h *postSettingHandler) Handle(param setting.PostSettingsParams) middleware.Responder {
	s, err := h.db.CreateSetting(param.HTTPRequest.Context(), param.Body.Name, param.Body.Value)
	if err != nil {
		return setting.NewPostSettingsBadRequest().WithPayload(controllers.MakeErrorPayload(err, controllers.BaseError))
	}

	return setting.NewPostSettingsOK().WithPayload(convert.SettingToSwagger(s))
}
