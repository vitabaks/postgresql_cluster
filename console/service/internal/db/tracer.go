package db

import (
	"context"
	"encoding/hex"
	"fmt"
	"postgresql-cluster-console/pkg/tracer"
	"strings"
	"time"

	"github.com/gdex-lab/go-render/render"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

type (
	traceCtxKey   struct{}
	traceCtxValue struct {
		startTime time.Time
		queryId   string
	}
	tracerZerolog struct{}
)

func NewTracerZerolog() pgx.QueryTracer {
	return tracerZerolog{}
}

func (t tracerZerolog) TraceQueryStart(
	ctx context.Context,
	conn *pgx.Conn,
	data pgx.TraceQueryStartData,
) context.Context {
	now := time.Now()
	queryId := uuid.New().String()
	localLog := t.makeTraceLogger(ctx, queryId)

	localLog.Debug().Str("sql", strings.Map(func(r rune) rune {
		switch r {
		case 0x000A, 0x0009, 0x000B, 0x000C, 0x000D, 0x0085, 0x2028, 0x2029:
			return -1
		default:
			return r
		}
	}, data.SQL)).Str("args", logQueryArgs(data.Args)).Msg("TraceQueryStart")

	return context.WithValue(ctx, traceCtxKey{}, &traceCtxValue{startTime: now, queryId: queryId})
}

func (t tracerZerolog) TraceQueryEnd(
	ctx context.Context,
	conn *pgx.Conn,
	data pgx.TraceQueryEndData,
) {
	traceValues, ok := ctx.Value(traceCtxKey{}).(*traceCtxValue)
	if !ok {
		return
	}

	localLog := t.makeTraceLogger(ctx, traceValues.queryId)
	msg := fmt.Sprintf("TraceQueryEnd duration: %s", time.Since(traceValues.startTime))
	if data.Err != nil {
		localLog.Error().Err(data.Err).Msg(msg)
	} else {
		localLog.Debug().Msg(msg)
	}
}

func (t tracerZerolog) makeTraceLogger(ctx context.Context, queryId string) zerolog.Logger {
	cid := getCid(ctx)
	logCtx := log.With().Str("query_id", queryId)
	if len(cid) != 0 {
		logCtx = logCtx.Str("cid", cid)
	}

	return logCtx.Logger()
}

func getCid(ctx context.Context) string {
	cid, ok := ctx.Value(tracer.CtxCidKey{}).(string)
	if !ok {
		return uuid.New().String()
	}

	return cid
}

func logQueryArgs(args []any) string {
	//logArgs := make([]string, 0, len(args))

	paramsStr := strings.Builder{}
	paramsStr.WriteString("(")

	for i, a := range args {
		switch v := a.(type) {
		case []byte:
			if len(v) < 64 {
				a = hex.EncodeToString(v)
			} else {
				a = fmt.Sprintf("%x (truncated %d bytes)", v[:64], len(v)-64)
			}
		case string:
			if len(v) > 64 {
				a = fmt.Sprintf("%s (truncated %d bytes)", v[:64], len(v)-64)
			}
		}
		if i != len(args)-1 {
			paramsStr.WriteString(",")
		}

		if stringer, ok := a.(fmt.Stringer); ok {
			paramsStr.WriteString(stringer.String())
		} else {
			paramsStr.WriteString(render.Render(a))
		}
	}

	paramsStr.WriteString(")")

	return paramsStr.String()
}
