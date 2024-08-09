package cluster

import (
	"context"
	"postgresql-cluster-console/internal/controllers"
	"postgresql-cluster-console/internal/convert"
	"postgresql-cluster-console/internal/storage"
	"postgresql-cluster-console/models"
	"postgresql-cluster-console/pkg/tracer"
	"postgresql-cluster-console/restapi/operations/cluster"
	"time"

	"github.com/go-openapi/runtime/middleware"
	"github.com/rs/zerolog"
)

type getClustersHandler struct {
	db  storage.IStorage
	log zerolog.Logger
}

func NewGetClustersHandler(db storage.IStorage, log zerolog.Logger) cluster.GetClustersHandler {
	return &getClustersHandler{
		db:  db,
		log: log,
	}
}

func (h *getClustersHandler) Handle(param cluster.GetClustersParams) middleware.Responder {
	cid := param.HTTPRequest.Context().Value(tracer.CtxCidKey{}).(string)
	localLog := h.log.With().Str("cid", cid).Logger()

	project, err := h.db.GetProject(param.HTTPRequest.Context(), param.ProjectID)
	if err != nil {
		return cluster.NewGetClustersBadRequest().WithPayload(controllers.MakeErrorPayload(err, controllers.BaseError))
	}

	clusters, meta, err := h.db.GetClusters(param.HTTPRequest.Context(), &storage.GetClustersReq{
		ProjectID:       param.ProjectID,
		Name:            param.Name,
		SortBy:          param.SortBy,
		Status:          param.Status,
		Location:        param.Location,
		ServerCount:     param.ServerCount,
		PostgresVersion: param.PostgresVersion,
		EnvironmentID: func() *int64 {
			if param.Environment == nil {
				return nil
			}
			environment, err := h.db.GetEnvironmentByName(param.HTTPRequest.Context(), *param.Environment)
			if err != nil {
				localLog.Error().Err(err).Msg("failed to get environment from db")

				return nil
			}

			return &environment.ID
		}(),
		CreatedAtFrom: (*time.Time)(param.CreatedAtFrom),
		CreatedAtTo:   (*time.Time)(param.CreatedAtTo),
		Limit:         param.Limit,
		Offset:        param.Offset,
	})
	if err != nil {
		return cluster.NewGetClustersBadRequest().WithPayload(controllers.MakeErrorPayload(err, controllers.BaseError))
	}

	clustersResp := models.ResponseClustersInfo{
		Data: make([]*models.ClusterInfo, 0, len(clusters)),
		Meta: &models.MetaPagination{
			Count:  &meta.Count,
			Limit:  &meta.Limit,
			Offset: &meta.Offset,
		},
	}

	cache := make(map[int64]string)
	for _, cl := range clusters {
		servers, err := h.db.GetClusterServers(param.HTTPRequest.Context(), cl.ID)
		if err != nil {
			return cluster.NewGetClustersBadRequest().WithPayload(controllers.MakeErrorPayload(err, controllers.BaseError))
		}
		environmentCode, err := h.getEnvironmentCode(param.HTTPRequest.Context(), cl.EnvironmentID, cache)
		if err != nil {
			return cluster.NewGetClustersBadRequest().WithPayload(controllers.MakeErrorPayload(err, controllers.BaseError))
		}

		clustersResp.Data = append(clustersResp.Data, convert.ClusterToSwagger(&cl, servers, environmentCode, project.Name))
	}

	return cluster.NewGetClustersOK().WithPayload(&clustersResp)
}

func (h *getClustersHandler) getEnvironmentCode(ctx context.Context, environmentID int64, cache map[int64]string) (string, error) {
	code, ok := cache[environmentID]
	if ok {
		return code, nil
	}

	environment, err := h.db.GetEnvironment(ctx, environmentID)
	if err != nil {
		return "", err
	}

	cache[environmentID] = environment.Name

	return environment.Name, nil
}
