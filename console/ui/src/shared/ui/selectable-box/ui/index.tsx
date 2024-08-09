import { FC } from 'react';
import { ClusterFormSelectableBoxProps } from '@shared/ui/selectable-box/model/types.ts';
import theme from '@shared/theme/theme.ts';
import { Box } from '@mui/material';

const SelectableBox: FC<ClusterFormSelectableBoxProps> = ({ isActive, children, sx, ...props }) => {
  return (
    <Box
      sx={{
        border: '1px solid #E0E0E0',
        outline: `${isActive && `2px solid ${theme.palette.primary.main}`}`,
        cursor: 'pointer',
        ...sx,
      }}
      {...props}>
      {children}
    </Box>
  );
};

export default SelectableBox;
