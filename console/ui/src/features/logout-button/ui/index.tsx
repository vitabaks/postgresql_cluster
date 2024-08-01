import { FC } from 'react';
import Logout from '@shared/assets/logoutIcon.svg?react';
import { Icon } from '@mui/material';
import { useNavigate } from 'react-router-dom';
import RouterPaths from '@app/router/routerPathsConfig';
import { generateAbsoluteRouterPath } from '@shared/lib/functions.ts';

const LogoutButton: FC = () => {
  const navigate = useNavigate();

  const handleLogout = () => {
    localStorage.removeItem('token');
    navigate(generateAbsoluteRouterPath(RouterPaths.login.absolutePath));
  };

  return (
    <Icon sx={{ cursor: 'pointer' }} onClick={handleLogout}>
      <Logout />
    </Icon>
  );
};

export default LogoutButton;
