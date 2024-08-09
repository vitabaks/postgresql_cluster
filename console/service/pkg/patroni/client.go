package patroni

import (
	"context"
	"encoding/json"
	"io"
	"net/http"
	"postgresql-cluster-console/pkg/tracer"
	"time"

	"github.com/rs/zerolog"
)

type IClient interface {
	GetMonitoringInfo(ctx context.Context, host string) (*MonitoringInfo, error)
	GetClusterInfo(ctx context.Context, host string) (*ClusterInfo, error)
}

type pClient struct {
	log        zerolog.Logger
	httpClient *http.Client
}

func NewClient(log zerolog.Logger) IClient {
	return pClient{
		log: log,
		httpClient: &http.Client{
			Timeout: time.Second,
		},
	}
}

func (c pClient) GetMonitoringInfo(ctx context.Context, host string) (*MonitoringInfo, error) {
	cid := ctx.Value(tracer.CtxCidKey{}).(string)
	localLog := c.log.With().Str("cid", cid).Logger()
	url := "http://" + host + ":8008/patroni"
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return nil, err
	}

	localLog.Trace().Str("request", "GET "+url).Msg("call request")
	resp, err := c.httpClient.Do(req)
	if err != nil {
		return nil, err
	}
	defer func() {
		derr := resp.Body.Close()
		if derr != nil {
			localLog.Error().Err(derr).Msg("failed to close body")
		}
	}()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}
	localLog.Trace().Str("response", string(body)).Msg("got response")

	var monitoringInfo MonitoringInfo
	err = json.Unmarshal(body, &monitoringInfo)
	if err != nil {
		return nil, err
	}

	return &monitoringInfo, nil
}

func (c pClient) GetClusterInfo(ctx context.Context, host string) (*ClusterInfo, error) {
	cid := ctx.Value(tracer.CtxCidKey{}).(string)
	localLog := c.log.With().Str("cid", cid).Logger()
	url := "http://" + host + ":8008/cluster"
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return nil, err
	}

	localLog.Trace().Str("request", "GET "+url).Msg("call request")
	resp, err := c.httpClient.Do(req)
	if err != nil {
		return nil, err
	}
	defer func() {
		derr := resp.Body.Close()
		if derr != nil {
			localLog.Error().Err(derr).Msg("failed to close body")
		}
	}()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}
	localLog.Trace().Str("response", string(body)).Msg("got response")

	var clusterInfo ClusterInfo
	err = json.Unmarshal(body, &clusterInfo)
	if err != nil {
		return nil, err
	}

	return &clusterInfo, nil
}
