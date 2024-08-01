import { lazy } from 'react';
import { Navigate, Route } from 'react-router-dom';
import RouterPaths from '@app/router/routerPathsConfig';

const Settings = lazy(() => import('@pages/settings'));
const SettingsForm = lazy(() => import('@widgets/settings-form'));
const SecretsTable = lazy(() => import('@widgets/secrets-table/ui'));
const ProjectsTable = lazy(() => import('@widgets/projects-table'));
const EnvironmentsTable = lazy(() => import('@widgets/environments-table'));

const SettingsRoutes = () => (
  <Route>
    <Route
      path={RouterPaths.settings.absolutePath}
      handle={{
        breadcrumb: { label: 'settings', ns: 'settings' },
      }}
      element={<Settings />}>
      <Route path="" element={<Navigate to={RouterPaths.settings.general.relativePath} replace />}></Route>
      <Route path={RouterPaths.settings.general.relativePath} element={<SettingsForm />} />
      <Route path={RouterPaths.settings.secrets.relativePath} element={<SecretsTable />} />
      <Route path={RouterPaths.settings.projects.relativePath} element={<ProjectsTable />} />
      <Route path={RouterPaths.settings.environments.relativePath} element={<EnvironmentsTable />} />
    </Route>
  </Route>
);

export default SettingsRoutes;
