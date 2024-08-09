package middleware

import (
	"encoding/json"
	"fmt"
	"net/http"
	"postgresql-cluster-console/models"
	"strings"
)

func Authorization(token string, next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		const (
			headerName = "Authorization"
			schemeName = "Bearer"
		)
		tokenVal := r.Header.Get(headerName)
		tokenValSplit := strings.Split(tokenVal, " ")
		if len(tokenValSplit) != 2 || tokenValSplit[0] != schemeName || tokenValSplit[1] != token {
			w.Header().Add("content-type", "application/json")
			w.WriteHeader(http.StatusUnauthorized)
			resp, _ := json.Marshal(&models.ResponseError{
				Code:        http.StatusUnauthorized,
				Description: fmt.Sprintf("token [%s] invalid", tokenVal),
				Title:       "Invalid token",
			})
			_, _ = w.Write(resp)

			return
		}

		next.ServeHTTP(w, r)
	})
}
