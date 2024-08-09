package controllers

import "postgresql-cluster-console/models"

func MakeErrorPayload(err error, code int64) *models.ResponseError {
	return &models.ResponseError{
		Code:        code,
		Description: err.Error(),
		Title:       err.Error(),
	}
}
