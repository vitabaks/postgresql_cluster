package setting

import (
	"github.com/go-openapi/runtime/middleware"
	"postgesql-cluster-console/internal/controllers"
	"postgesql-cluster-console/internal/convert"
	"postgesql-cluster-console/internal/storage"
	"postgesql-cluster-console/restapi/operations/setting"
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
