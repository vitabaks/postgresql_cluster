import React from 'react';
import { useTranslation } from 'react-i18next';
import { Controller, useFormContext } from 'react-hook-form';
import { Stack, TextField } from '@mui/material';

import { SECRET_MODAL_CONTENT_FORM_FIELD_NAMES } from '@entities/secret-form-block/model/constants.ts';

const PasswordSecretBlock: React.FC = () => {
  const { t } = useTranslation('shared');
  const {
    control,
    formState: { errors },
  } = useFormContext();

  return (
    <Stack direction="column" gap="16px" width="100%">
      <Controller
        control={control}
        name={SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.USERNAME}
        render={({ field: { value, onChange } }) => (
          <TextField
            required
            value={value}
            onChange={onChange}
            fullWidth
            error={!!errors[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.USERNAME]}
            helperText={errors[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.USERNAME]?.message ?? ''}
            size="small"
            label={t('username')}
          />
        )}
      />
      <Controller
        control={control}
        name={SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.PASSWORD}
        render={({ field: { value, onChange } }) => (
          <TextField
            required
            value={value}
            onChange={onChange}
            error={!!errors[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.PASSWORD]}
            helperText={errors[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.PASSWORD]?.message ?? ''}
            size="small"
            label={t('password')}
          />
        )}
      />
    </Stack>
  );
};

export default PasswordSecretBlock;
