import { PROVIDERS } from '@shared/config/constants.ts';

import { SECRET_MODAL_CONTENT_FORM_FIELD_NAMES } from '@entities/secret-form-block/model/constants.ts';

export const CLUSTER_SECRET_MODAL_FORM_FIELD_NAMES = Object.freeze({
  ...SECRET_MODAL_CONTENT_FORM_FIELD_NAMES,
  IS_SAVE_TO_CONSOLE: 'isSaveToConsole',
});

export const PROVIDER_CODE_TO_ANSIBLE_USER_MAP = Object.freeze({
  [PROVIDERS.AWS]: 'ubuntu',
  [PROVIDERS.GCP]: 'root',
  [PROVIDERS.AZURE]: 'azureadmin',
  [PROVIDERS.DIGITAL_OCEAN]: 'root',
  [PROVIDERS.HETZNER]: 'root',
});
