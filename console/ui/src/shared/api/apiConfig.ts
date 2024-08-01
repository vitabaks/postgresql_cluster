import type { ConfigFile } from '@rtk-query/codegen-openapi';

const config: ConfigFile = {
  schemaFile: '../../../../service/api/swagger.yaml',
  apiFile: './baseApi.ts',
  apiImport: 'baseApi',
  outputFiles: {
    './generatedApi/clusters.ts': {
      filterEndpoints: [/cluster/i],
      exportName: 'clustersApi',
    },
    './generatedApi/environments.ts': {
      filterEndpoints: [/environment/i],
      exportName: 'environmentsApi',
    },
    './generatedApi/projects.ts': {
      filterEndpoints: [/project/i],
      exportName: 'projectsApi',
    },
    './generatedApi/secrets.ts': {
      filterEndpoints: [/secret/i],
      exportName: 'secretsApi',
    },
    './generatedApi/operations.ts': {
      filterEndpoints: [/operation/i],
      exportName: 'operationsApi',
    },
    './generatedApi/deployments.ts': {
      filterEndpoints: [/deployment/i],
      exportName: 'deploymentsApi',
    },
    './generatedApi/settings.ts': {
      filterEndpoints: [/settings/i],
      exportName: 'settingsApi',
    },
    './generatedApi/other.ts': {
      filterEndpoints: [/^((?!(cluster|environment|project|secret|operation|deployment|settings)).)*$/i],
      exportName: 'otherApi',
    },
  },
  exportName: 'postgresClusterConsoleApi',
  hooks: { queries: true, lazyQueries: true, mutations: true },
};

export default config;
