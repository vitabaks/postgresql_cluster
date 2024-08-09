package middleware

import (
	"bytes"
	"encoding/json"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"io"
	"net/http"
	"time"
)

const XCorrID = "X-Correlation-Id"

const responseWriterBodyLimit = 10000

type responseWriter struct {
	http.ResponseWriter
	body         []byte
	statusCode   int
	bodyOverflow bool
}

func GetResponseWriterCode(w http.ResponseWriter) int {
	if wNew, ok := w.(*responseWriter); ok {
		return wNew.statusCode
	}
	return 0
}

func (r *responseWriter) Write(b []byte) (int, error) {
	if len(r.body) < responseWriterBodyLimit {
		maxWriteLen := responseWriterBodyLimit - len(r.body)
		if len(b) > maxWriteLen {
			r.body = append(r.body, b[:maxWriteLen]...)
			r.bodyOverflow = true
		} else {
			r.body = append(r.body, b...)
		}
	}

	return r.ResponseWriter.Write(b)
}

func (r *responseWriter) WriteHeader(statusCode int) {
	r.statusCode = statusCode
	r.ResponseWriter.WriteHeader(statusCode)
}

func (r *responseWriter) zerologResponse(log zerolog.Logger) {
	body := r.prepareBodyForLog()

	log.Debug().
		Any("body", body).
		Any("headers", r.Header()).
		Int("status", r.getStatusCode()).Msg("[zerologResponse] Response was sent")
}

func (r *responseWriter) getStatusCode() int {
	if r.statusCode == 0 {
		return 200
	}

	return r.statusCode
}

func (r *responseWriter) prepareBodyForLog() any {
	var body map[string]interface{}
	if r.bodyOverflow {
		return r.body
	}
	_ = json.Unmarshal(r.body, &body)
	replaceFields(body, secretFields)

	return body
}

var secretFields = map[string]string{
	"AWS_SECRET_ACCESS_KEY":        "***",
	"GCP_SERVICE_ACCOUNT_CONTENTS": "***",
	"HCLOUD_API_TOKEN":             "***",
	"SSH_PRIVATE_KEY":              "***",
	"DO_API_TOKEN":                 "***",
	"PASSWORD":                     "***",
	"password":                     "***",
	"AZURE_SECRET":                 "***",
}

func RequestZeroLog(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		cid := r.Header.Get(XCorrID)
		clog := log.With().
			Str("cid", cid).
			Str("method", r.Method).
			Str("path", r.URL.String()).
			Str("protocol", r.Proto).
			Int64("request_length", r.ContentLength).
			Logger()

		var (
			body     []byte
			bodyInt  map[string]interface{}
			bodyCopy io.ReadCloser
			err      error
		)

		if r.Body != nil && r.Body != http.NoBody {
			bodyCopy, r.Body, err = drainBody(r.Body)
			if err == nil {
				body, err = io.ReadAll(bodyCopy)
				if err != nil {
					clog.Error().Err(err).Msg("[RequestZeroLog] read body error")
				}
			} else {
				clog.Error().Err(err).Msg("[RequestZeroLog] drainBody failed")
			}
		}

		err = json.Unmarshal(body, &bodyInt)
		if err != nil {
			clog.Debug().
				Any("headers", r.Header).
				Any("query", r.URL.Query()).
				Bytes("body", body).
				Msg("[RequestLog] request accepted")
		} else {
			replaceFields(bodyInt, secretFields)
			clog.Debug().
				Any("headers", r.Header).
				Any("query", r.URL.Query()).
				Any("body", bodyInt).
				Msg("[RequestLog] request accepted")
		}

		w.Header().Set(XCorrID, cid)

		start := time.Now()
		wExt := &responseWriter{ResponseWriter: w}
		next.ServeHTTP(wExt, r)
		duration := time.Since(start)

		wExt.zerologResponse(clog)

		clog.Debug().
			Int("status", wExt.getStatusCode()).
			Dur("handle_time", duration). // request_time
			Int("response_length", len(wExt.body)).
			Msg("[RequestLog] request completed")
	})
}

// drainBody reads all of b to memory and then returns two equivalent
// ReadClosers yielding the same bytes.
//
// It returns an error if the initial slurp of all bytes fails. It does not attempt
// to make the returned ReadClosers have identical error-matching behavior.
func drainBody(b io.ReadCloser) (r1, r2 io.ReadCloser, err error) {
	var buf bytes.Buffer
	if _, err = buf.ReadFrom(b); err != nil {
		return nil, b, err
	}
	if err = b.Close(); err != nil {
		return nil, b, err
	}
	return io.NopCloser(&buf), io.NopCloser(bytes.NewReader(buf.Bytes())), nil
}
