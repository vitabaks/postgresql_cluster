import { SECRET_MODAL_CONTENT_FORM_FIELD_NAMES } from '@entities/secret-form-block/model/constants.ts';

export const ADD_SECRET_FORM_FIELD_NAMES = Object.freeze({
  SECRET_NAME: 'secretName',
  ...SECRET_MODAL_CONTENT_FORM_FIELD_NAMES,
});
