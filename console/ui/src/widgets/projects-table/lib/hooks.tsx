import { useMemo } from 'react';
import { ResponseProject } from '@shared/api/api/projects.ts';
import { PROJECTS_TABLE_COLUMN_NAMES } from '@widgets/projects-table/model/constants.ts';

export const useGetProjectsTableData = (data: ResponseProject[]) =>
  useMemo(
    () =>
      data?.map((secret) => ({
        [PROJECTS_TABLE_COLUMN_NAMES.ID]: secret.id,
        [PROJECTS_TABLE_COLUMN_NAMES.NAME]: secret.name,
        [PROJECTS_TABLE_COLUMN_NAMES.CREATED]: secret.created_at,
        [PROJECTS_TABLE_COLUMN_NAMES.UPDATED]: secret.updated_at,
        [PROJECTS_TABLE_COLUMN_NAMES.DESCRIPTION]: secret.description ?? '-',
      })) ?? [],
    [data],
  );
