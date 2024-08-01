import { lazy } from 'react';
import { Route } from 'react-router-dom';
import RouterPaths from '@app/router/routerPathsConfig';
import OperationLog from '@pages/operation-log';

const Operations = lazy(() => import('@pages/operations'));

const OperationsRoutes = () => (
  <Route>
    <Route
      path={RouterPaths.operations.absolutePath}
      handle={{
        breadcrumb: { label: 'operations', ns: 'operations' },
      }}>
      <Route path="" element={<Operations />} />
      <Route
        path={RouterPaths.operations.log.relativePath}
        handle={{
          breadcrumb: {
            label: (data: any) => `${data.operationId}`,
          },
        }}
        element={<OperationLog />}
      />
    </Route>
  </Route>
);

export default OperationsRoutes;
