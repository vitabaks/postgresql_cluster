import { FC } from 'react';
import { CopyIconProps } from '@shared/ui/copy-icon/model/types.ts';
import { useCopyToClipboard } from '@shared/lib/hooks.tsx';
import CopyValueIcon from '@shared/ui/copy-icon/assets/copyIcon.svg?react';
import { Box } from '@mui/material';

const CopyIcon: FC<CopyIconProps> = ({ valueToCopy }) => {
  const [_, copyFunction] = useCopyToClipboard();

  return (
    <Box onClick={() => copyFunction(valueToCopy)} sx={{ cursor: 'pointer' }}>
      <CopyValueIcon />
    </Box>
  );
};

export default CopyIcon;
