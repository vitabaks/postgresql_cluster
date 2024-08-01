const routerClustersPathsConfig = {
  absolutePath: '/clusters',
  add: {
    absolutePath: '/clusters/add',
    relativePath: 'add',
  },
  overview: {
    absolutePath: '/clusters/:clusterId/overview',
    relativePath: ':clusterId/overview',
  },
};

export default routerClustersPathsConfig;
