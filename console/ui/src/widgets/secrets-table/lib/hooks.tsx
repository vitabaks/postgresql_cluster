import { ResponseSecretInfo } from '@shared/api/api/secrets.ts';
import { useMemo } from 'react';
import { SECRETS_TABLE_COLUMN_NAMES } from '@widgets/secrets-table/model/constants.ts';

export const useGetSecretsTableData = (data: ResponseSecretInfo[]) =>
  useMemo(
    () =>
      data?.map((secret) => ({
        [SECRETS_TABLE_COLUMN_NAMES.NAME]: secret.name!,
        [SECRETS_TABLE_COLUMN_NAMES.TYPE]: secret.type!,
        [SECRETS_TABLE_COLUMN_NAMES.CREATED]: secret.created_at,
        [SECRETS_TABLE_COLUMN_NAMES.UPDATED]: secret.updated_at,
        [SECRETS_TABLE_COLUMN_NAMES.USED]: String(!!secret.is_used),
        [SECRETS_TABLE_COLUMN_NAMES.ID]: secret.id!,
        [SECRETS_TABLE_COLUMN_NAMES.USED_BY]: secret.used_by_clusters, // not displayed, required only for logic purposed
      })) ?? [],
    [data],
  );
