import { FC } from 'react';
import { Link } from 'react-router-dom';
import { ListItemButton, ListItemIcon, ListItemText } from '@mui/material';
import theme from '@shared/theme/theme.ts';
import { SidebarItemProps } from '@entities/sidebar-item/model/types.ts';

const SidebarItemContent: FC<SidebarItemProps> = ({
  path,
  label,
  icon: SidebarIcon,
  isActive,
  target,
  isCollapsed,
}) => {
  return (
    <ListItemButton
      sx={{
        gap: '16px',
        borderLeft: `4px solid ${isActive ? theme.palette.primary.main : 'transparent'}`,
        height: '50px',
      }}
      to={path}
      target={target}
      component={Link}>
      <ListItemIcon
        sx={{
          minWidth: 'fit-content',
        }}>
        {SidebarIcon ? <SidebarIcon width="24px" height="24px" /> : null}
      </ListItemIcon>
      {!isCollapsed ? <ListItemText primary={label} /> : null}
    </ListItemButton>
  );
};

export default SidebarItemContent;
