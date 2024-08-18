import { FC, Suspense } from 'react';
import { Divider, Stack, Toolbar } from '@mui/material';
import { Outlet } from 'react-router-dom';
import Breadcrumbs from '@features/bradcrumbs';
import Spinner from '@shared/ui/spinner';

const Main: FC = () => (
  <main style={{ display: 'flex', overflow: 'auto', width: '100%', padding: '8px' }}>
    <Stack width="100%">
      <Toolbar />
      <Breadcrumbs />
      <Divider />
      <Suspense fallback={<Spinner />}>
        <Outlet />
      </Suspense>
    </Stack>
  </main>
);

export default Main;
