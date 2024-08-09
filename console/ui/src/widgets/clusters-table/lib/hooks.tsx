import { useMemo } from 'react';
import {
  CLUSTER_STATUSES,
  CLUSTER_TABLE_COLUMN_NAMES,
  clusterStatusColorNamesMap,
} from '@widgets/clusters-table/model/constants.ts';
import { CircularProgress, Link, Stack, Typography } from '@mui/material';
import { generateAbsoluteRouterPath } from '@shared/lib/functions.ts';
import RouterPaths from '@app/router/routerPathsConfig';
import { ClusterInfo } from '@shared/api/api/clusters.ts';

export const useGetClustersTableData = (data: ClusterInfo[]) =>
  useMemo(
    () =>
      data?.map((cluster) => ({
        [CLUSTER_TABLE_COLUMN_NAMES.NAME]: [CLUSTER_STATUSES.DEPLOYING, CLUSTER_STATUSES.FAILED].some(
          (status) => status === cluster.status,
        ) ? (
          <Typography>{cluster.name}</Typography>
        ) : (
          <Link
            href={
              generateAbsoluteRouterPath(RouterPaths.clusters.overview.absolutePath, {
                clusterId: cluster.id,
              }).pathname
            }>
            {cluster.name}
          </Link>
        ),
        [CLUSTER_TABLE_COLUMN_NAMES.STATUS]: (
          <Stack direction="row" gap={1} alignItems="center">
            {cluster.status === CLUSTER_STATUSES.DEPLOYING ? (
              <CircularProgress size={14} />
            ) : clusterStatusColorNamesMap[cluster.status] ? (
              <img src={clusterStatusColorNamesMap[cluster.status]} alt={cluster.status} width="16px" />
            ) : null}
            <Typography>{cluster.status}</Typography>
          </Stack>
        ),
        [CLUSTER_TABLE_COLUMN_NAMES.CREATION_TIME]: cluster.creation_time,
        [CLUSTER_TABLE_COLUMN_NAMES.ENVIRONMENT]: cluster.environment,
        [CLUSTER_TABLE_COLUMN_NAMES.SERVERS]: cluster.servers?.length ?? '-',
        [CLUSTER_TABLE_COLUMN_NAMES.POSTGRES_VERSION]: cluster?.postgres_version ?? '-',
        [CLUSTER_TABLE_COLUMN_NAMES.LOCATION]: cluster?.cluster_location ?? '-',
        [CLUSTER_TABLE_COLUMN_NAMES.ID]: cluster.id, // not displayed, required only for correct cluster removal
      })) ?? [],
    [data],
  );
