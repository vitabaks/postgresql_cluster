package xdocker

import (
	"bytes"
	"io"
	"net/http"
	"postgresql-cluster-console/pkg/tracer"

	"github.com/docker/docker/client"
	"github.com/docker/go-connections/sockets"
	"github.com/rs/zerolog"
)

type roundTripperLog struct {
	http.Transport
	log zerolog.Logger
}

func NewRoundTripperLog(host string, log zerolog.Logger) (http.RoundTripper, error) {
	rt := &roundTripperLog{
		log: log,
	}

	hostURL, err := client.ParseHostURL(host)
	if err != nil {
		return nil, err
	}

	err = sockets.ConfigureTransport(&rt.Transport, hostURL.Scheme, hostURL.Host)
	if err != nil {
		return nil, err
	}

	return rt, nil
}

func (rt *roundTripperLog) RoundTrip(request *http.Request) (*http.Response, error) {
	var (
		copyBody io.ReadCloser
		err      error
	)
	localLog := rt.log.With().Str("cid", request.Context().Value(tracer.CtxCidKey{}).(string)).Logger()
	if request.Body != nil {
		copyBody, err = request.GetBody()
		if err != nil {
			localLog.Error().Err(err).Msgf("failed to GetBody")
		} else {
			defer func() {
				err = copyBody.Close()
				if err != nil {
					localLog.Error().Err(err).Msg("failed to close copy of body")
				}
			}()
			body, err := io.ReadAll(copyBody)
			if err != nil {
				localLog.Error().Err(err).Msg("failed to ReadAll request body")
			} else {
				localLog.Trace().Str("url", request.URL.Path).Str("host", request.URL.Host).Str("method", request.Method).Str("body", string(body)).Msg("request body")
			}
		}
	} else {
		localLog.Trace().Str("url", request.URL.Path).Str("host", request.URL.Host).Str("method", request.Method).Msg("request")
	}

	res, err := rt.Transport.RoundTrip(request)
	if err != nil {
		localLog.Error().Err(err).Msg("failed to RoundTrip")
	} else {
		var respBody io.ReadCloser
		respBody, res.Body, err = drainBody(res.Body)
		if err != nil {
			localLog.Error().Err(err).Msg("failed to drain body")
		} else {
			defer func() {
				err = respBody.Close()
				if err != nil {
					localLog.Error().Err(err).Msg("failed to close response body")
				}
			}()
			body, err := io.ReadAll(respBody)
			if err != nil {
				localLog.Error().Err(err).Msg("failed to ReadAll response body")
			} else {
				localLog.Trace().Str("url", request.URL.Path).Str("host", request.URL.Host).Str("body", string(body)).Msg("response body")
			}
		}
	}

	return res, err
}

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
