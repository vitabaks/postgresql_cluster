package migrations

import (
	"github.com/pressly/goose/v3"
	"github.com/rs/zerolog"
)

type zeroLogAdapter struct {
	log zerolog.Logger
}

func NewZeroLogAdapter(log zerolog.Logger) goose.Logger {
	return zeroLogAdapter{log: log.With().Str("module", "goouse").Logger()}
}

func (l zeroLogAdapter) Fatalf(format string, v ...interface{}) {
	l.log.Error().Msgf(format, v...)
}

func (l zeroLogAdapter) Printf(format string, v ...interface{}) {
	l.log.Info().Msgf(format, v...)
}
