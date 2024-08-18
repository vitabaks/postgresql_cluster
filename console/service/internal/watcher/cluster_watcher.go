package watcher

import (
	"context"
	"postgresql-cluster-console/internal/configuration"
	"postgresql-cluster-console/internal/storage"
	"postgresql-cluster-console/pkg/patroni"
	"postgresql-cluster-console/pkg/tracer"
	"sync"
	"time"

	"github.com/google/uuid"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"go.openly.dev/pointy"
	"golang.org/x/sync/semaphore"
)

type ClusterWatcher interface {
	Run()
	Stop()
	HandleCluster(ctx context.Context, cl *storage.Cluster)
}

type clusterWatcher struct {
	db         storage.IStorage
	isRun      bool
	log        zerolog.Logger
	cfg        *configuration.Config
	patroniCli patroni.IClient

	ctx  context.Context
	done context.CancelFunc
	wg   sync.WaitGroup
}

func NewServerWatcher(db storage.IStorage, patroniCli patroni.IClient, cfg *configuration.Config) ClusterWatcher {
	return &clusterWatcher{
		db:         db,
		cfg:        cfg,
		patroniCli: patroniCli,
		log:        log.Logger.With().Str("module", "cluster_watcher").Logger(),
	}
}

func (sw *clusterWatcher) Run() {
	if sw.isRun {
		return
	}
	sw.isRun = true

	sw.ctx, sw.done = context.WithCancel(context.Background())
	sw.wg.Add(1)
	go func() {
		sw.loop()
		sw.wg.Done()
	}()
	sw.log.Info().Msg("run")
}

func (sw *clusterWatcher) Stop() {
	sw.log.Info().Msg("stopping")
	sw.done()
	sw.wg.Wait()
	sw.isRun = false
	sw.log.Info().Msg("stopped")
}

func (sw *clusterWatcher) loop() {
	timer := time.NewTimer(sw.cfg.ClusterWatcher.RunEvery)
	defer timer.Stop()

	for {
		select {
		case <-sw.ctx.Done():
			sw.log.Info().Msg("loop is done")

			return
		case <-timer.C:
			sw.doWork()
			timer.Reset(sw.cfg.ClusterWatcher.RunEvery)
		}
	}
}

func (sw *clusterWatcher) doWork() {
	sw.log.Trace().Msg("doWork started")
	defer sw.log.Trace().Msg("doWork was done")
	ctx := context.WithValue(sw.ctx, tracer.CtxCidKey{}, uuid.New().String())
	projects, _, err := sw.db.GetProjects(ctx, pointy.Int64(1000), pointy.Int64(0))
	if err != nil {
		sw.log.Error().Err(err).Msg("failed to get projects")

		return
	}
	sem := semaphore.NewWeighted(sw.cfg.ClusterWatcher.PoolSize)
	for _, pr := range projects {
		sw.handleProject(ctx, &pr, sem)
	}
	_ = sem.Acquire(ctx, sw.cfg.ClusterWatcher.PoolSize) // wait all workers done
}

func (sw *clusterWatcher) handleProject(ctx context.Context, pr *storage.Project, sem *semaphore.Weighted) {
	localLog := sw.log.With().Str("project", pr.Name).Logger()
	localLog.Trace().Msg("started to handler project")
	defer log.Trace().Msg("project was handled")

	var (
		offset = int64(0)
		limit  = int64(100) // handle by 100 clusters per call
	)
	for {
		if ctx.Err() != nil {
			return
		}

		clusters, _, err := sw.db.GetClusters(ctx, &storage.GetClustersReq{
			ProjectID: pr.ID,
			Limit:     &limit,
			Offset:    &offset,
		})
		if err != nil {
			localLog.Error().Err(err).Msg("failed to get clusters")

			continue
		}
		if len(clusters) == 0 {
			localLog.Trace().Msg("all clusters were handled")

			return
		}

		for _, cl := range clusters {
			err = sem.Acquire(ctx, 1)
			if err != nil {
				localLog.Error().Err(err).Msg("failed to acquire semaphore")

				return
			}
			cl := cl // copy for async handling
			go func() {
				sw.HandleCluster(ctx, &cl)
				sem.Release(1)
			}()
		}
		offset += limit
	}
}

func (sw *clusterWatcher) HandleCluster(ctx context.Context, cl *storage.Cluster) {
	localLog := sw.log.With().Str("cluster", cl.Name).Logger()
	cid, ok := ctx.Value(tracer.CtxCidKey{}).(string)
	if ok {
		localLog.With().Str("cid", cid).Logger()
	}
	localLog.Trace().Msg("started to handle cluster")
	defer localLog.Trace().Msg("cluster was handled")

	servers, err := sw.db.GetClusterServers(ctx, cl.ID)
	if err != nil {
		localLog.Error().Err(err).Msg("failed to get servers by cluster")

		return
	}

	sw.handleClusterServers(ctx, cl, servers)
}

func (sw *clusterWatcher) handleClusterServers(ctx context.Context, cl *storage.Cluster, clusterServers []storage.Server) {
	localLog := sw.log.With().Str("cluster", cl.Name).Logger()
	cid, ok := ctx.Value(tracer.CtxCidKey{}).(string)
	if ok {
		localLog.With().Str("cid", cid).Logger()
	}
	localLog.Trace().Msg("started to handle cluster servers")
	defer localLog.Trace().Msg("cluster servers were handled")

	// map with old cluster topology
	serversMap := make(map[string]bool)
	for _, s := range clusterServers {
		serversMap[s.IpAddress.String()] = false
	}

	patroniHealthCheck := false
	for _, s := range clusterServers {
		if ctx.Err() != nil {
			return
		}

		clusterInfo, err := sw.patroniCli.GetClusterInfo(ctx, s.IpAddress.String())
		if err != nil {
			localLog.Debug().Err(err).Msg("failed to get patroni info")

			continue
		}
		localLog.Trace().Any("cluster_info", &clusterInfo).Msg("got cluster info")
		patroniHealthCheck = true

		const (
			stateRunning   = "running"
			stateStreaming = "streaming"
		)
		healthyServers := int32(0)

		for _, serverInfo := range clusterInfo.Members {
			var lag *int64
			switch l := serverInfo.Lag.(type) {
			case int64:
				lag = &l
			case uint64:
				lag = pointy.Int64(int64(l))
			case int8:
				lag = pointy.Int64(int64(l))
			case uint8:
				lag = pointy.Int64(int64(l))
			case int16:
				lag = pointy.Int64(int64(l))
			case uint16:
				lag = pointy.Int64(int64(l))
			case int:
				lag = pointy.Int64(int64(l))
			case uint:
				lag = pointy.Int64(int64(l))
			case int32:
				lag = pointy.Int64(int64(l))
			case uint32:
				lag = pointy.Int64(int64(l))
			case float64:
				lag = pointy.Int64(int64(l))
			default:
				localLog.Trace().Type("lag_type", l).Msg("unknown lag type")
			}
			updatedServer, err := sw.db.UpdateServer(ctx, &storage.UpdateServerReq{
				ClusterID:      cl.ID,
				IpAddress:      serverInfo.Host,
				Name:           serverInfo.Name,
				Role:           &serverInfo.Role,
				Status:         &serverInfo.State,
				Timeline:       &serverInfo.Timeline,
				Lag:            lag,
				Tags:           &serverInfo.Tags,
				PendingRestart: &serverInfo.PendingRestart,
			})
			if err != nil {
				localLog.Error().Err(err).Msg("failed to update server")
			} else {
				localLog.Trace().Any("server", updatedServer).Msg("server was updated")
				serversMap[serverInfo.Host] = true
			}
			if serverInfo.State == stateRunning || serverInfo.State == stateStreaming {
				healthyServers++
			}
		}
		var status string
		if len(clusterInfo.Members) < int(cl.ServersCount) {
			status = storage.ClusterStatusDegraded
		} else if healthyServers < cl.ServersCount {
			status = storage.ClusterStatusUnhealthy
		} else {
			status = storage.ClusterStatusHealthy
		}
		_, err = sw.db.UpdateCluster(ctx, &storage.UpdateClusterReq{
			ID:     cl.ID,
			Status: &status,
			Flags:  storage.SetPatroniConnectStatus(cl.Flags, 1),
		})
		if err != nil {
			localLog.Error().Err(err).Msg("failed to update cluster status")
		}
		break
	}
	if !patroniHealthCheck && storage.GetPatroniConnectStatus(cl.Flags) == 1 {
		_, err := sw.db.UpdateCluster(ctx, &storage.UpdateClusterReq{
			ID:     cl.ID,
			Status: pointy.String(storage.ClusterStatusUnavailable),
		})
		if err != nil {
			localLog.Error().Err(err).Msg("failed to update cluster status")
		}
	}

	for ipAddress, updated := range serversMap {
		if !updated {
			updatedServer, err := sw.db.ResetServer(ctx, cl.ID, ipAddress)
			if err != nil {
				localLog.Error().Err(err).Msg("failed to update unknown server")
			} else {
				localLog.Trace().Any("server", updatedServer).Msg("unknown server was updated")
			}
		}
	}
}
