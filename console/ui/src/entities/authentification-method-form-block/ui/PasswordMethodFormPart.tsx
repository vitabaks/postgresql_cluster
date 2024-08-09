import React, { FC } from 'react';
import { Controller, useFormContext } from 'react-hook-form';
import { TextField } from '@mui/material';
import { useTranslation } from 'react-i18next';
import { SECRET_MODAL_CONTENT_FORM_FIELD_NAMES } from '@entities/secret-form-block/model/constants.ts';

const PasswordMethodFormPart: FC = () => {
  const { t } = useTranslation('shared');

  const {
    control,
    formState: { errors },
  } = useFormContext();

  return (
    <>
      <Controller
        control={control}
        name={SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.PASSWORD}
        render={({ field: { value, onChange } }) => (
          <TextField
            fullWidth
            required
            value={value as string}
            onChange={onChange}
            label={t('password', { ns: 'shared' })}
            error={!!errors[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.PASSWORD]}
            helperText={errors[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.PASSWORD]?.message ?? ''}
            size="small"
          />
        )}
      />
    </>
  );
};

export default PasswordMethodFormPart;
