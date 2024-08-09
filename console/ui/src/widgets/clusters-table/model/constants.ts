import CorrectIcon from '../assets/correctIcon.svg';
import WarningIcon from '../assets/warningIcon.svg';
import ErrorIcon from '../assets/errorIcon.svg';

export const CLUSTER_TABLE_COLUMN_NAMES = Object.freeze({
  // names are used as sorting params, changes will break sorting
  NAME: 'name',
  STATUS: 'status',
  CREATION_TIME: 'created_at',
  ENVIRONMENT: 'environment',
  SERVERS: 'server_count',
  POSTGRES_VERSION: 'postgres_version',
  LOCATION: 'location',
  ACTIONS: 'actions',
  ID: 'id',
});

export const CLUSTER_STATUSES = Object.freeze({
  DEPLOYING: 'deploying',
  READY: 'ready',
  FAILED: 'failed',
  HEALTHY: 'healthy',
  UNHEALTHY: 'unhealthy',
  DEGRADED: 'degraded',
  UNAVAILABLE: 'unavailable',
});

export const clusterStatusColorNamesMap = Object.freeze({
  [CLUSTER_STATUSES.HEALTHY]: CorrectIcon,
  [CLUSTER_STATUSES.UNHEALTHY]: WarningIcon,
  [CLUSTER_STATUSES.DEGRADED]: ErrorIcon,
  [CLUSTER_STATUSES.UNAVAILABLE]: ErrorIcon,
});
