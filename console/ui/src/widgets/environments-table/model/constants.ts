import { createMRTColumnHelper } from 'material-react-table';
import { TFunction } from 'i18next';
import { convertTimestampToReadableTime } from '@shared/lib/functions.ts';
import { EnvironmentTableValues } from '@widgets/environments-table/model/types.ts';

export const ENVIRONMENTS_TABLE_COLUMN_NAMES = Object.freeze({
  ID: 'id',
  NAME: 'name',
  DESCRIPTION: 'description',
  CREATED: 'created_at',
  UPDATED: 'updated_at',
});

const columnHelper = createMRTColumnHelper<EnvironmentTableValues>();

export const environmentTableColumns = (t: TFunction) => [
  columnHelper.accessor(ENVIRONMENTS_TABLE_COLUMN_NAMES.ID, {
    header: t('id', { ns: 'shared' }),
    size: 80,
    grow: true,
  }),
  columnHelper.accessor(ENVIRONMENTS_TABLE_COLUMN_NAMES.NAME, {
    header: t('name', { ns: 'shared' }),
    size: 80,
    grow: true,
  }),
  columnHelper.accessor(ENVIRONMENTS_TABLE_COLUMN_NAMES.CREATED, {
    header: t('created', { ns: 'shared' }),
    size: 150,
    grow: true,
    Cell: ({ cell }) => convertTimestampToReadableTime(cell.getValue()), // convert back to string for display
  }),
  columnHelper.accessor(ENVIRONMENTS_TABLE_COLUMN_NAMES.UPDATED, {
    header: t('updated', { ns: 'shared' }),
    size: 150,
    grow: true,
    Cell: ({ cell }) => convertTimestampToReadableTime(cell.getValue()), // convert back to string for display
  }),
  columnHelper.accessor(ENVIRONMENTS_TABLE_COLUMN_NAMES.DESCRIPTION, {
    header: t('description', { ns: 'shared' }),
    size: 150,
    grow: true,
  }),
];
