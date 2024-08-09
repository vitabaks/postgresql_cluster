package storage

import "go.openly.dev/pointy"

const (
	patroniConnectStatusMaskSet    = uint32(0x1)
	patroniConnectStatusMaskRemove = uint32(0xfffffff6)
)

func SetPatroniConnectStatus(oldMask uint32, status uint32) *uint32 {
	return pointy.Uint32((oldMask & patroniConnectStatusMaskRemove) | (status & patroniConnectStatusMaskSet))
}

func GetPatroniConnectStatus(mask uint32) uint32 {
	return mask & patroniConnectStatusMaskSet
}
