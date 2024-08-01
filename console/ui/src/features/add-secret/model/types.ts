import { ADD_SECRET_FORM_FIELD_NAMES } from '@features/add-secret/model/constants.ts';

import { SecretFormValues } from '@entities/secret-form-block/model/types.ts';

export interface AddSecretFormValues extends SecretFormValues {
  [ADD_SECRET_FORM_FIELD_NAMES.SECRET_NAME]: string;
}
