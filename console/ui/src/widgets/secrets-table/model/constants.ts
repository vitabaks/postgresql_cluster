import { TFunction } from 'i18next';
import { createMRTColumnHelper } from 'material-react-table';
import { SecretsTableValues } from '@widgets/secrets-table/model/types.ts';
import { convertTimestampToReadableTime } from '@shared/lib/functions.ts';

export const SECRETS_TABLE_COLUMN_NAMES = Object.freeze({
  NAME: 'name',
  TYPE: 'type',
  CREATED: 'created',
  UPDATED: 'updated',
  USED: 'used',
  ID: 'id',
  USED_BY: 'usedBy',
});

const columnHelper = createMRTColumnHelper<SecretsTableValues>();

export const secretsTableColumns = (t: TFunction) => [
  columnHelper.accessor(SECRETS_TABLE_COLUMN_NAMES.NAME, {
    header: t('name', { ns: 'shared' }),
    size: 80,
    grow: true,
  }),
  columnHelper.accessor(SECRETS_TABLE_COLUMN_NAMES.TYPE, {
    header: t('type', { ns: 'shared' }),
    size: 80,
    grow: true,
  }),
  columnHelper.accessor(SECRETS_TABLE_COLUMN_NAMES.CREATED, {
    header: t('created', { ns: 'shared' }),
    size: 150,
    grow: true,
    Cell: ({ cell }) => convertTimestampToReadableTime(cell.getValue()), // convert back to string for display
  }),
  columnHelper.accessor(SECRETS_TABLE_COLUMN_NAMES.UPDATED, {
    header: t('updated', { ns: 'shared' }),
    size: 150,
    grow: true,
    Cell: ({ cell }) => convertTimestampToReadableTime(cell.getValue()), // convert back to string for display
  }),
  columnHelper.accessor(SECRETS_TABLE_COLUMN_NAMES.USED, {
    header: t('used', { ns: 'shared' }),
    size: 150,
    grow: true,
  }),
  columnHelper.accessor(SECRETS_TABLE_COLUMN_NAMES.ID, {
    header: t('id', { ns: 'shared' }),
    size: 80,
    grow: true,
  }),
];
