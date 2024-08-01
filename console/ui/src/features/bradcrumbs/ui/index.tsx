import { FC } from 'react';
import BreadcrumbsItem from '@entities/breadcumb-item';
import useBreadcrumbs from '@/features/bradcrumbs/hooks/useBreadcrumbs.tsx';
import { Breadcrumbs as MaterialBreadcrumbs, Icon, Link, Typography } from '@mui/material';
import RouterPaths from '@app/router/routerPathsConfig';
import HomeOutlinedIcon from '@mui/icons-material/HomeOutlined';
import { generateAbsoluteRouterPath } from '@shared/lib/functions.ts';

const Breadcrumbs: FC = () => {
  const breadcrumbs = useBreadcrumbs();

  return (
    <MaterialBreadcrumbs>
      <Link
        underline="hover"
        color="inherit"
        href={generateAbsoluteRouterPath(RouterPaths.clusters.absolutePath).pathname}>
        <Icon>
          <HomeOutlinedIcon />
        </Icon>
      </Link>
      {breadcrumbs.map((breadcrumb, index) =>
        index === breadcrumbs.length - 1 ? (
          <Typography key={breadcrumb.path} color="text.primary">
            {breadcrumb.label}
          </Typography>
        ) : (
          <BreadcrumbsItem key={breadcrumb.path} {...breadcrumb} />
        ),
      )}
    </MaterialBreadcrumbs>
  );
};

export default Breadcrumbs;
