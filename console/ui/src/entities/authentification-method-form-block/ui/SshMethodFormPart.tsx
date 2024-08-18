import React, { FC } from 'react';
import { Controller, useFormContext } from 'react-hook-form';
import { TextField } from '@mui/material';
import { useTranslation } from 'react-i18next';
import { SECRET_MODAL_CONTENT_FORM_FIELD_NAMES } from '@entities/secret-form-block/model/constants.ts';

const SshMethodFormPart: FC = () => {
  const { t } = useTranslation(['clusters', 'shared', 'settings']);

  const {
    control,
    formState: { errors },
  } = useFormContext();

  return (
    <>
      <Controller
        control={control}
        name={SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.SSH_PRIVATE_KEY}
        render={({ field: { value, onChange } }) => (
          <TextField
            fullWidth
            required
            multiline
            minRows={2}
            maxRows={6}
            value={value as string}
            placeholder={t('sshKeyLocalMachinePlaceholder')}
            onChange={onChange}
            label={t('sshKey', { ns: 'clusters' })}
            error={!!errors[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.SSH_PRIVATE_KEY]}
            helperText={errors[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.SSH_PRIVATE_KEY]?.message ?? ''}
          />
        )}
      />
    </>
  );
};

export default SshMethodFormPart;
