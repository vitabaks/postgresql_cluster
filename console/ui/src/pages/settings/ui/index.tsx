import { FC } from 'react';
import { Divider, Tab, Tabs } from '@mui/material';
import { Link, Outlet, useLocation } from 'react-router-dom';
import { settingsTabsContent } from '@pages/settings/model/constants.ts';
import { useTranslation } from 'react-i18next';
import { generateAbsoluteRouterPath } from '@shared/lib/functions.ts';

const Settings: FC = () => {
  const { t } = useTranslation('settings');
  const location = useLocation();

  return (
    <>
      <Tabs value={location.pathname}>
        {settingsTabsContent.map((tabContent) => (
          <Tab
            key={tabContent.path}
            label={t(tabContent.translateKey)}
            value={tabContent.path}
            to={generateAbsoluteRouterPath(tabContent.path)}
            component={Link}
          />
        ))}
      </Tabs>
      <Divider />
      <Outlet />
    </>
  );
};

export default Settings;
