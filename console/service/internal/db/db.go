package db

import (
	"context"
	"fmt"
	"postgresql-cluster-console/internal/configuration"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
)

func NewDbPool(cfg *configuration.Config) (*pgxpool.Pool, error) {
	connString := fmt.Sprintf("postgres://%s:%s@%s:%d/%s",
		cfg.Db.User, cfg.Db.Password, cfg.Db.Host, cfg.Db.Port, cfg.Db.DbName)
	poolConfig, err := pgxpool.ParseConfig(connString)
	if err != nil {
		return nil, err
	}
	//poolConfig.ConnConfig.PreferSimpleProtocol = true //(don't need simple protocol https://github.com/jackc/pgx/issues/650)
	poolConfig.ConnConfig.Tracer = NewTracerZerolog()
	poolConfig.MaxConns = cfg.Db.MaxConns
	poolConfig.HealthCheckPeriod = time.Minute * 10
	if cfg.Db.MaxConnLifeTime != 0 {
		poolConfig.MaxConnLifetime = cfg.Db.MaxConnLifeTime
	}
	if cfg.Db.MaxConnIdleTime != 0 {
		poolConfig.MaxConnIdleTime = cfg.Db.MaxConnIdleTime
	}

	return pgxpool.NewWithConfig(context.Background(), poolConfig)
}
