package watcher

import (
	"context"
	"postgresql-cluster-console/internal/storage"
	"postgresql-cluster-console/internal/xdocker"
	"postgresql-cluster-console/pkg/tracer"
	"sync"

	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

type LogCollector interface {
	StoreInDb(operationID int64, dockerCode xdocker.InstanceID, cid string)
	PrintToConsole(dockerCode xdocker.InstanceID, cid string)
	Stop()
}

type logCollector struct {
	db            storage.IStorage
	dockerManager xdocker.IManager
	isRun         bool
	log           zerolog.Logger

	ctx  context.Context
	done context.CancelFunc
	wg   sync.WaitGroup
}

func NewLogCollector(db storage.IStorage, dockerManager xdocker.IManager) LogCollector {
	lc := &logCollector{
		db:            db,
		dockerManager: dockerManager,
		log:           log.Logger.With().Str("module", "log_collector").Logger(),
	}
	lc.ctx, lc.done = context.WithCancel(context.Background())

	return lc
}

func (lc *logCollector) StoreInDb(operationID int64, dockerCode xdocker.InstanceID, cid string) {
	lc.wg.Add(1)
	go func() {
		lc.log.Debug().Str("cid", cid).Int64("operation_id", operationID).Msg("log collector started")
		lc.storeLogsFromContainer(operationID, dockerCode, cid)
		defer func() {
			lc.wg.Done()
			lc.log.Debug().Str("cid", cid).Int64("operation_id", operationID).Msg("finished")
		}()
	}()
}

func (lc *logCollector) PrintToConsole(dockerCode xdocker.InstanceID, cid string) {
	lc.wg.Add(1)
	go func() {
		lc.log.Debug().Str("cid", cid).Msg("log collector started")
		lc.printLogsFromContainer(dockerCode, cid)
		defer func() {
			lc.wg.Done()
			lc.log.Debug().Str("cid", cid).Msg("finished")
		}()
	}()
}

func (lc *logCollector) Stop() {
	lc.log.Info().Msg("stopping")
	lc.done()
	lc.wg.Wait()
	lc.log.Info().Msg("stopped")
}

func (lc *logCollector) storeLogsFromContainer(operationID int64, dockerCode xdocker.InstanceID, cid string) {
	ctx := context.WithValue(lc.ctx, tracer.CtxCidKey{}, cid)
	lc.log.Trace().Msg("storeLogsFromContainer called")
	lc.dockerManager.StoreContainerLogs(ctx, dockerCode, func(logMessage string) {
		lc.log.Trace().Str("cid", cid).Str("proc", "storeLogsFromContainer").Msg(logMessage)
		_, err := lc.db.UpdateOperation(ctx, &storage.UpdateOperationReq{
			ID:   operationID,
			Logs: &logMessage,
		})
		if err != nil {
			lc.log.Error().Err(err).Int64("operation_id", operationID).Msg("failed to update log")
		}
	})
}

func (lc *logCollector) printLogsFromContainer(dockerCode xdocker.InstanceID, cid string) {
	ctx := context.WithValue(lc.ctx, tracer.CtxCidKey{}, cid)
	lc.log.Trace().Msg("storeLogsFromContainer called")
	lc.dockerManager.StoreContainerLogs(ctx, dockerCode, func(logMessage string) {
		lc.log.Trace().Str("cid", cid).Msg(logMessage)
	})
}
