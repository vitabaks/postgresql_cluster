import routerClustersPathsConfig from '@app/router/routerPathsConfig/routerClustersPathsConfig.ts';
import routerOperationsPathsConfig from '@app/router/routerPathsConfig/routerOperationsPathsConfig.ts';
import routerSettingsPathsConfig from '@app/router/routerPathsConfig/routerSettingsPathsConfig.ts';

/*
  Combines route paths into one config
 */
const RouterPaths = {
  login: {
    absolutePath: 'login',
  },
  notFound: {
    absolutePath: 'notFound',
  },
  clusters: routerClustersPathsConfig,
  operations: routerOperationsPathsConfig,
  settings: routerSettingsPathsConfig,
} as const;

export default RouterPaths;
