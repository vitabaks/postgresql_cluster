import { Navigate, Outlet, useLocation } from 'react-router-dom';
import RouterPaths from '@app/router/routerPathsConfig';
import { FC, useEffect } from 'react';
import { toast } from 'react-toastify';
import { useTranslation } from 'react-i18next';
import { AUTH_TOKEN } from '@shared/config/constants.ts';

const PrivateRouteWrapper: FC = () => {
  const { t } = useTranslation('toasts');
  const location = useLocation();

  useEffect(() => {
    const token = localStorage.getItem('token');
    if (token && token !== AUTH_TOKEN) toast.error(t('invalidToken'));
  }, [localStorage.getItem('token')]);

  return localStorage.getItem('token') === AUTH_TOKEN ? (
    <Outlet />
  ) : (
    <Navigate to={RouterPaths.login.absolutePath} replace state={{ path: location.pathname }} />
  );
};

export default PrivateRouteWrapper;
