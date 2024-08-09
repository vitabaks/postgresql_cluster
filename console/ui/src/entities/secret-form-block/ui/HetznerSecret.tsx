import React from 'react';
import { Controller, useFormContext } from 'react-hook-form';
import { Stack, TextField } from '@mui/material';

import { SECRET_MODAL_CONTENT_FORM_FIELD_NAMES } from '@entities/secret-form-block/model/constants.ts';

const HetznerSecretBlock: React.FC = () => {
  const {
    control,
    formState: { errors },
  } = useFormContext();

  return (
    <Stack direction="column" gap="16px" width="100%">
      <Controller
        control={control}
        name={SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.HCLOUD_API_TOKEN}
        render={({ field: { value, onChange } }) => (
          <TextField
            required
            value={value}
            onChange={onChange}
            error={!!errors[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.HCLOUD_API_TOKEN]}
            helperText={errors[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.HCLOUD_API_TOKEN]?.message ?? ''}
            size="small"
            label="HCLOUD_API_TOKEN"
          />
        )}
      />
    </Stack>
  );
};

export default HetznerSecretBlock;
