package storage

import (
	"gotest.tools/v3/assert"
	"testing"
)

func TestClusterFlags(t *testing.T) {
	assert.Equal(t, uint32(1), *SetPatroniConnectStatus(0, 1))
	assert.Equal(t, uint32(1), *SetPatroniConnectStatus(1, 1))
	assert.Equal(t, uint32(0x11), *SetPatroniConnectStatus(0x10, 1))
	assert.Equal(t, uint32(0), *SetPatroniConnectStatus(1, 0))
}
