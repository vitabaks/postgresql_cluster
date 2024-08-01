import { FC } from 'react';
import { Controller, useFormContext } from 'react-hook-form';
import { Stack, TextField } from '@mui/material';
import { useTranslation } from 'react-i18next';

import { SECRET_MODAL_CONTENT_FORM_FIELD_NAMES } from '@entities/secret-form-block/model/constants.ts';

const SshKeySecretBlock: FC = () => {
  const { t } = useTranslation('settings');
  const {
    control,
    formState: { errors },
  } = useFormContext();

  return (
    <Stack direction="column" gap="16px" width="100%">
      <Controller
        control={control}
        name={SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.SSH_PRIVATE_KEY}
        render={({ field: { value, onChange } }) => (
          <TextField
            required
            multiline
            rows={6}
            value={value}
            onChange={onChange}
            error={!!errors[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.SSH_PRIVATE_KEY]}
            helperText={errors[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.SSH_PRIVATE_KEY]?.message ?? ''}
            size="small"
            label={t('sshPrivateKey')}
          />
        )}
      />
    </Stack>
  );
};

export default SshKeySecretBlock;
