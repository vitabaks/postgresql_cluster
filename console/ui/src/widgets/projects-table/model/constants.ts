import { createMRTColumnHelper } from 'material-react-table';
import { TFunction } from 'i18next';
import { convertTimestampToReadableTime } from '@shared/lib/functions.ts';
import { ProjectsTableValues } from '@widgets/projects-table/model/types.ts';

export const PROJECTS_TABLE_COLUMN_NAMES = Object.freeze({
  ID: 'id',
  NAME: 'name',
  DESCRIPTION: 'description',
  CREATED: 'created_at',
  UPDATED: 'updated_at',
});

const columnHelper = createMRTColumnHelper<ProjectsTableValues>();

export const projectsTableColumns = (t: TFunction) => [
  columnHelper.accessor(PROJECTS_TABLE_COLUMN_NAMES.ID, {
    header: t('id', { ns: 'shared' }),
    size: 80,
    grow: true,
  }),
  columnHelper.accessor(PROJECTS_TABLE_COLUMN_NAMES.NAME, {
    header: t('name', { ns: 'shared' }),
    size: 80,
    grow: true,
  }),
  columnHelper.accessor(PROJECTS_TABLE_COLUMN_NAMES.CREATED, {
    header: t('created', { ns: 'shared' }),
    size: 150,
    grow: true,
    Cell: ({ cell }) => convertTimestampToReadableTime(cell.getValue()), // convert back to string for display
  }),
  columnHelper.accessor(PROJECTS_TABLE_COLUMN_NAMES.UPDATED, {
    header: t('updated', { ns: 'shared' }),
    size: 150,
    grow: true,
    Cell: ({ cell }) => convertTimestampToReadableTime(cell.getValue()), // convert back to string for display
  }),
  columnHelper.accessor(PROJECTS_TABLE_COLUMN_NAMES.DESCRIPTION, {
    header: t('description', { ns: 'shared' }),
    size: 150,
    grow: true,
  }),
];
