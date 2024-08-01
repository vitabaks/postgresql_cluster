import { FC } from 'react';
import { Controller, useFormContext } from 'react-hook-form';
import { Stack, TextField } from '@mui/material';

import { SECRET_MODAL_CONTENT_FORM_FIELD_NAMES } from '@entities/secret-form-block/model/constants.ts';

const GcpSecretBlock: FC = () => {
  const {
    control,
    formState: { errors },
  } = useFormContext();

  return (
    <Stack direction="column" gap="16px" width="100%">
      <Controller
        control={control}
        name={SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.GCP_SERVICE_ACCOUNT_CONTENTS}
        render={({ field: { value, onChange } }) => (
          <TextField
            required
            multiline
            rows={6}
            value={value}
            onChange={onChange}
            error={!!errors[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.GCP_SERVICE_ACCOUNT_CONTENTS]}
            helperText={errors[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.GCP_SERVICE_ACCOUNT_CONTENTS]?.message ?? ''}
            size="small"
            label="GCP_SERVICE_ACCOUNT_CONTENTS"
          />
        )}
      />
    </Stack>
  );
};

export default GcpSecretBlock;
