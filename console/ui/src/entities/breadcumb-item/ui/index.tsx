import { FC } from 'react';
import { Link } from '@mui/material';
import { BreadcrumbsItemProps } from '@entities/breadcumb-item/model/types.ts';

const BreadcrumbsItem: FC<BreadcrumbsItemProps> = ({ label, path }) => (
  <Link underline="hover" color="inherit" href={path}>
    {label}
  </Link>
);

export default BreadcrumbsItem;
