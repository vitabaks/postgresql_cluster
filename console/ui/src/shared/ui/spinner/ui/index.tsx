import { FC } from 'react';
import { CircularProgress, Stack } from '@mui/material';

const Spinner: FC = () => {
  return (
    <Stack alignItems="center" justifyContent="stretch" spacing={5} padding="48px">
      <CircularProgress size={48} />
    </Stack>
  );
};

export default Spinner;
