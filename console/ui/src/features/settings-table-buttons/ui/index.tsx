import React from 'react';
import { useTranslation } from 'react-i18next';
import { Stack } from '@mui/material';
import SettingsAddSecret from '@features/add-secret';

const SettingsTableButtons: React.FC = () => {
  const { t } = useTranslation(['shared', 'settings']);

  return (
    <Stack direction="row" justifyContent="flex-end" gap="8px">
      <SettingsAddSecret />
    </Stack>
  );
};

export default SettingsTableButtons;
