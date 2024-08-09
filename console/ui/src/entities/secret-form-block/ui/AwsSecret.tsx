import { FC } from 'react';
import { Controller, useFormContext } from 'react-hook-form';
import { Stack, TextField } from '@mui/material';

import { SECRET_MODAL_CONTENT_FORM_FIELD_NAMES } from '@entities/secret-form-block/model/constants.ts';

const AwsSecretBlock: FC = () => {
  const {
    control,
    formState: { errors },
  } = useFormContext();

  return (
    <Stack direction="column" gap="16px" width="100%">
      <Controller
        control={control}
        name={SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AWS_ACCESS_KEY_ID}
        render={({ field: { value, onChange } }) => (
          <TextField
            required
            value={value}
            onChange={onChange}
            error={!!errors[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AWS_ACCESS_KEY_ID]}
            helperText={errors[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AWS_ACCESS_KEY_ID]?.message ?? ''}
            size="small"
            label="AWS_ACCESS_KEY_ID"
          />
        )}
      />
      <Controller
        control={control}
        name={SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AWS_SECRET_ACCESS_KEY}
        render={({ field: { value, onChange } }) => (
          <TextField
            required
            value={value}
            onChange={onChange}
            error={!!errors[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AWS_SECRET_ACCESS_KEY]}
            helperText={errors[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AWS_SECRET_ACCESS_KEY]?.message ?? ''}
            size="small"
            label="AWS_SECRET_ACCESS_KEY"
          />
        )}
      />
    </Stack>
  );
};

export default AwsSecretBlock;
