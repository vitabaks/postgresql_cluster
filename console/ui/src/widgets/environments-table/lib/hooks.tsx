import { useMemo } from 'react';
import { ENVIRONMENTS_TABLE_COLUMN_NAMES } from '@widgets/environments-table/model/constants.ts';
import { ResponseEnvironment } from '@shared/api/api/environments.ts';

export const useGetEnvironmentsTableData = (data: ResponseEnvironment[]) =>
  useMemo(
    () =>
      data?.map((secret) => ({
        [ENVIRONMENTS_TABLE_COLUMN_NAMES.ID]: secret.id,
        [ENVIRONMENTS_TABLE_COLUMN_NAMES.NAME]: secret.name,
        [ENVIRONMENTS_TABLE_COLUMN_NAMES.CREATED]: secret.created_at,
        [ENVIRONMENTS_TABLE_COLUMN_NAMES.UPDATED]: secret.updated_at,
        [ENVIRONMENTS_TABLE_COLUMN_NAMES.DESCRIPTION]: secret.description ?? '-',
      })) ?? [],
    [data],
  );
