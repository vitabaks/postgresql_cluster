package middleware

import (
	"context"
	"github.com/google/uuid"
	"net/http"
	"postgesql-cluster-console/pkg/tracer"
)

func SetCorrelationId(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		cid := getCid(r)
		if r.Header.Get(XCorrID) == "" {
			r.Header.Set(XCorrID, cid)
		}

		ctx := context.WithValue(r.Context(), tracer.CtxCidKey{}, cid)
		next.ServeHTTP(w, r.WithContext(ctx))
	})
}

func getCid(r *http.Request) string {
	cid := r.Header.Get(XCorrID)
	if cid != "" {
		return cid
	}

	return uuid.New().String()
}
