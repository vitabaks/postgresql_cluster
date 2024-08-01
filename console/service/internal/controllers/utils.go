package controllers

import "postgesql-cluster-console/models"

func MakeErrorPayload(err error, code int64) *models.ResponseError {
	return &models.ResponseError{
		Code:        code,
		Description: err.Error(),
		Title:       err.Error(),
	}
}
