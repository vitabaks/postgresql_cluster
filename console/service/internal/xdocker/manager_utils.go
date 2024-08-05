package xdocker

import (
	"context"
	"io"
	"postgresql-cluster-console/pkg/tracer"
	"strings"

	"github.com/docker/docker/api/types/image"
	"github.com/docker/docker/errdefs"
)

func (m *dockerManager) pullImage(ctx context.Context, dockerImage string) error {
	localLog := m.log.With().Str("cid", ctx.Value(tracer.CtxCidKey{}).(string)).Logger()
	inspectRes, _, err := m.cli.ImageInspectWithRaw(ctx, dockerImage)
	if err != nil {
		if _, ok := err.(errdefs.ErrNotFound); !ok {
			localLog.Error().Err(err).Msg("failed to inspect docker image")

			return err
		}
	}
	if err == nil && inspectRes.ID != "" {
		return nil // already has locally
	}
	out, err := m.cli.ImagePull(ctx, dockerImage, image.PullOptions{})
	if err != nil {
		localLog.Error().Err(err).Str("docker_image", dockerImage).Msg("failed to pull docker image")

		return err
	}
	defer func() {
		err = out.Close()
		if err != nil {
			localLog.Warn().Err(err).Msg("failed to close image_pull output")
		}
	}()

	buf := strings.Builder{}
	_, _ = io.Copy(&buf, out)
	localLog.Trace().Str("log", buf.String()).Msg("pull image")

	return nil
}
