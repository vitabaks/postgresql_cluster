import { SECRETS_TABLE_COLUMN_NAMES } from '@widgets/secrets-table/model/constants.ts';

export interface SecretsTableValues {
  [SECRETS_TABLE_COLUMN_NAMES.NAME]: string;
  [SECRETS_TABLE_COLUMN_NAMES.TYPE]: string;
  [SECRETS_TABLE_COLUMN_NAMES.CREATED]: string;
  [SECRETS_TABLE_COLUMN_NAMES.UPDATED]: string;
  [SECRETS_TABLE_COLUMN_NAMES.USED]: string;
  [SECRETS_TABLE_COLUMN_NAMES.ID]: number;
}
