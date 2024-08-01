import RouterPaths from '@app/router/routerPathsConfig';

export const settingsTabsContent = [
  {
    translateKey: 'generalSettings',
    path: RouterPaths.settings.general.absolutePath,
  },
  {
    translateKey: 'secrets',
    path: RouterPaths.settings.secrets.absolutePath,
  },
  {
    translateKey: 'projects',
    path: RouterPaths.settings.projects.absolutePath,
  },
  {
    translateKey: 'environments',
    path: RouterPaths.settings.environments.absolutePath,
  },
];
