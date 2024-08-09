import Index from '@app/router/routerPathsConfig';
import { convertTimestampToReadableTime, generateAbsoluteRouterPath } from '@shared/lib/functions.ts';
import { NavigateFunction } from 'react-router-dom';
import { createMRTColumnHelper } from 'material-react-table';
import { ClustersTableValues } from '@widgets/clusters-table/model/types.ts';
import { RankingInfo, rankings, rankItem } from '@tanstack/match-sorter-utils';
import { CLUSTER_STATUSES, CLUSTER_TABLE_COLUMN_NAMES } from '@widgets/clusters-table/model/constants.ts';

export const createClusterButtonHandler = (navigate: NavigateFunction) => () =>
  navigate(generateAbsoluteRouterPath(Index.clusters.add.absolutePath));

const columnHelper = createMRTColumnHelper<ClustersTableValues>();

export const getClusterTableColumns = ({ t, environmentOptions, postgresVersionOptions }) => [
  // note: changing table cell items content might need new custom filter function
  columnHelper.accessor(CLUSTER_TABLE_COLUMN_NAMES.NAME, {
    header: t('clusterName', { ns: 'clusters' }),
    filterFn: (row: Row<TData>, id: string, filterValue: string | number, addMeta: (item: RankingInfo) => void) => {
      // custom filter callback because of ReactNode as values
      const itemRank = rankItem(row.getValue(CLUSTER_TABLE_COLUMN_NAMES.NAME).props.children, filterValue as string, {
        threshold: rankings.MATCHES,
      });
      addMeta(itemRank);
      return itemRank.passed;
    },
    size: 150,
    enableHiding: false,
    grow: true,
    visibleInShowHideMenu: false,
  }),
  columnHelper.accessor(CLUSTER_TABLE_COLUMN_NAMES.STATUS, {
    header: t('status', { ns: 'shared' }),
    size: 120,
    filterVariant: 'select',
    filterSelectOptions: Object.values(CLUSTER_STATUSES),
    filterFn: (row: Row<TData>, id: string, filterValue: string | number, addMeta: (item: RankingInfo) => void) => {
      const itemRank = rankItem(
        row.getValue(CLUSTER_TABLE_COLUMN_NAMES.STATUS).props.children[1].props.children, // custom filter callback because of ReactNode as values
        filterValue as string,
        {
          threshold: rankings.MATCHES,
        },
      );
      addMeta(itemRank);
      return itemRank.passed;
    },
    grow: true,
  }),
  columnHelper.accessor(CLUSTER_TABLE_COLUMN_NAMES.CREATION_TIME, {
    accessorFn: (originalRow) => new Date(originalRow[CLUSTER_TABLE_COLUMN_NAMES.CREATION_TIME]), //convert to date for sorting and filtering
    header: t('creationTime', { ns: 'clusters' }),
    size: 260,
    filterVariant: 'date-range',
    grow: true,
    muiFilterTextFieldProps: { sx: { display: 'flex', flexDirection: 'column' } },
    muiFilterDatePickerProps: { sx: { display: 'flex', flexDirection: 'column' }, size: 'small' },
    Cell: ({ cell }) => convertTimestampToReadableTime(cell.getValue()), // convert back to string to display
  }),
  columnHelper.accessor(CLUSTER_TABLE_COLUMN_NAMES.ENVIRONMENT, {
    header: t('environment', { ns: 'shared' }),
    size: 140,
    filterVariant: 'select',
    filterSelectOptions: environmentOptions,
    grow: true,
  }),
  columnHelper.accessor(CLUSTER_TABLE_COLUMN_NAMES.SERVERS, {
    header: t('servers', { ns: 'clusters' }),
    size: 120,
    grow: true,
  }),
  columnHelper.accessor(CLUSTER_TABLE_COLUMN_NAMES.POSTGRES_VERSION, {
    header: t('postgresVersion', { ns: 'clusters' }),
    size: 150,
    filterVariant: 'select',
    filterSelectOptions: postgresVersionOptions,
    grow: true,
  }),
  columnHelper.accessor(CLUSTER_TABLE_COLUMN_NAMES.LOCATION, {
    header: t('location', { ns: 'clusters' }),
    grow: true,
  }),
];
