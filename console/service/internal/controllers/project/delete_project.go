package project

import (
	"fmt"
	"github.com/go-openapi/runtime/middleware"
	"github.com/rs/zerolog"
	"postgesql-cluster-console/internal/controllers"
	"postgesql-cluster-console/internal/storage"
	"postgesql-cluster-console/pkg/tracer"
	"postgesql-cluster-console/restapi/operations/project"
	"strings"
)

type deleteProjectHandler struct {
	db  storage.IStorage
	log zerolog.Logger
}

func NewDeleteProjectHandler(db storage.IStorage, log zerolog.Logger) project.DeleteProjectsIDHandler {
	return &deleteProjectHandler{
		db:  db,
		log: log,
	}
}

func (h *deleteProjectHandler) Handle(param project.DeleteProjectsIDParams) middleware.Responder {
	cid := param.HTTPRequest.Context().Value(tracer.CtxCidKey{}).(string)
	localLog := h.log.With().Str("cid", cid).Logger()
	checkClusters, _, err := h.db.GetClusters(param.HTTPRequest.Context(), &storage.GetClustersReq{
		ProjectID: param.ID,
	})
	if err != nil {
		localLog.Warn().Err(err).Msg("failed to check that project is used")
	} else if len(checkClusters) != 0 {
		return project.NewDeleteProjectsIDBadRequest().WithPayload(controllers.MakeErrorPayload(fmt.Errorf("The project is used by %d cluster(s) (%s)", len(checkClusters), getClustersNameTitle(checkClusters)), controllers.BaseError))
	}
	err = h.db.DeleteProject(param.HTTPRequest.Context(), param.ID)
	if err != nil {
		return project.NewDeleteProjectsIDBadRequest().WithPayload(controllers.MakeErrorPayload(err, controllers.BaseError))
	}

	return project.NewDeleteProjectsIDNoContent()
}

func getClustersNameTitle(clusters []storage.Cluster) string {
	const maxSize = 3
	title := strings.Builder{}
	for i, cl := range clusters {
		if i >= maxSize {
			title.WriteString(",...")

			return title.String()
		}
		if i != 0 {
			title.WriteString(",")
		}
		title.WriteString(cl.Name)
	}

	return title.String()
}
