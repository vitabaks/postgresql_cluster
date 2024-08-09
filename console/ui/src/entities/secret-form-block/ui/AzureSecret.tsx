import { FC } from 'react';
import { Controller, useFormContext } from 'react-hook-form';
import { Stack, TextField } from '@mui/material';

import { SECRET_MODAL_CONTENT_FORM_FIELD_NAMES } from '@entities/secret-form-block/model/constants.ts';

const AzureSecretBlock: FC = () => {
  const {
    control,
    formState: { errors },
  } = useFormContext();

  return (
    <Stack direction="column" gap="16px" width="100%">
      <Controller
        control={control}
        name={SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AZURE_SUBSCRIPTION_ID}
        render={({ field: { value, onChange } }) => (
          <TextField
            required
            value={value}
            onChange={onChange}
            error={!!errors[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AZURE_SUBSCRIPTION_ID]}
            helperText={errors[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AZURE_SUBSCRIPTION_ID]?.message ?? ''}
            size="small"
            label="AZURE_SUBSCRIPTION_ID"
          />
        )}
      />
      <Controller
        control={control}
        name={SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AZURE_CLIENT_ID}
        render={({ field: { value, onChange } }) => (
          <TextField
            required
            value={value}
            onChange={onChange}
            error={!!errors[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AZURE_CLIENT_ID]}
            helperText={errors[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AZURE_CLIENT_ID]?.message ?? ''}
            size="small"
            label="AZURE_CLIENT_ID"
          />
        )}
      />
      <Controller
        control={control}
        name={SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AZURE_SECRET}
        render={({ field: { value, onChange } }) => (
          <TextField
            required
            value={value}
            onChange={onChange}
            error={!!errors[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AZURE_SECRET]}
            helperText={errors[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AZURE_SECRET]?.message ?? ''}
            size="small"
            label="AZURE_SECRET"
          />
        )}
      />
      <Controller
        control={control}
        name={SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AZURE_TENANT}
        render={({ field: { value, onChange } }) => (
          <TextField
            required
            value={value}
            onChange={onChange}
            error={!!errors[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AZURE_TENANT]}
            helperText={errors[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AZURE_TENANT]?.message ?? ''}
            size="small"
            label="AZURE_TENANT"
          />
        )}
      />
    </Stack>
  );
};

export default AzureSecretBlock;
