package setting

import (
	"github.com/go-openapi/runtime/middleware"
	"postgesql-cluster-console/internal/controllers"
	"postgesql-cluster-console/internal/convert"
	"postgesql-cluster-console/internal/storage"
	"postgesql-cluster-console/restapi/operations/setting"
)

type patchSettingHandler struct {
	db storage.IStorage
}

func NewPatchSettingHandler(db storage.IStorage) setting.PatchSettingsNameHandler {
	return &patchSettingHandler{
		db: db,
	}
}

func (h *patchSettingHandler) Handle(param setting.PatchSettingsNameParams) middleware.Responder {
	s, err := h.db.UpdateSetting(param.HTTPRequest.Context(), param.Name, param.Body.Value)
	if err != nil {
		return setting.NewPatchSettingsNameBadRequest().WithPayload(controllers.MakeErrorPayload(err, controllers.BaseError))
	}

	return setting.NewPatchSettingsNameOK().WithPayload(convert.SettingToSwagger(s))
}
