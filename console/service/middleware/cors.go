package middleware

import "net/http"

func CORS(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {

		w.Header().Set("Access-Control-Allow-Credentials", "true")
		w.Header().Set("Access-Control-Allow-Methods", " GET, POST, OPTIONS, PATCH, DELETE, PUT")
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Expose-Headers", "X-Log-Completed, X-Cluster-Id")
		w.Header().Set("Access-Control-Allow-Headers", "Authorization, Access-Control-Allow-Origin, Access-Control-Allow-Headers, Origin,Accept, "+
			"X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers, X-Log-Completed, X-Cluster-Id")

		if r.Method != http.MethodOptions {
			next.ServeHTTP(w, r)
		}
	})
}
