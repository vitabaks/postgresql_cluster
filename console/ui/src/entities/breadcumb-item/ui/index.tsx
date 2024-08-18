import { FC } from 'react';
import { BreadcrumbsItemProps } from '@entities/breadcumb-item/model/types.ts';
import { Link } from 'react-router-dom';

const BreadcrumbsItem: FC<BreadcrumbsItemProps> = ({ label, path }) => (
  <Link style={{ textDecoration: 'none', color: 'rgba(0, 0, 0, 0.87)' }} to={path}>
    {label}
  </Link>
);

export default BreadcrumbsItem;
