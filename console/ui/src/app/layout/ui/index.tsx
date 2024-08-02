import { FC } from 'react';
import Sidebar from '@widgets/sidebar';
import Header from '@widgets/header';
import Main from '@widgets/main';

const Layout: FC = () => {
  return (
    <div style={{ display: 'flex', overflow: 'auto', height: '100vh' }}>
      <Header />
      <Sidebar />
      <Main />
    </div>
  );
};

export default Layout;
