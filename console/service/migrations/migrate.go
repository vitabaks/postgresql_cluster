package migrations

import (
	"context"

	"github.com/rs/zerolog/log"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/jackc/pgx/v5/stdlib"
	"github.com/pressly/goose/v3"
)

func Migrate(dbPool *pgxpool.Pool, migrationDir string) error {
	db := stdlib.OpenDBFromPool(dbPool)
	goose.SetLogger(NewZeroLogAdapter(log.Logger))

	return goose.RunContext(context.Background(), "up", db, migrationDir)
}
