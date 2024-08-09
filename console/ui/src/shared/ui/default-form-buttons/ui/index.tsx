import { FC } from 'react';
import { useTranslation } from 'react-i18next';
import styled from '@emotion/styled';
import { LoadingButton } from '@mui/lab';
import { DefaultFormButtonsProps } from '@shared/ui/default-form-buttons/model/types.ts';
import { CircularProgress } from '@mui/material';

const StyledDefaultFormButtons = styled.div`
  display: flex;
  align-items: center;
  justify-content: space-between;
`;

const StyledStandardButtons = styled.div`
  display: grid;
  grid-template: 1fr / repeat(2, auto);
  grid-column-gap: 16px;
  width: fit-content;
`;

const DefaultFormButtons: FC<DefaultFormButtonsProps> = ({
  isDisabled = false,
  isSubmitting = false,
  cancelHandler,
  submitButtonLabel,
  cancelButtonLabel,
  children,
}) => {
  const { t } = useTranslation('shared');

  return (
    <StyledDefaultFormButtons>
      <StyledStandardButtons>
        <LoadingButton
          variant="contained"
          disabled={isDisabled}
          loading={isSubmitting}
          loadingIndicator={<CircularProgress size={24} />}
          type="submit">
          <span>{submitButtonLabel ?? t('save')}</span>
        </LoadingButton>
        <LoadingButton variant="outlined" onClick={cancelHandler} type="button">
          <span>{cancelButtonLabel ?? t('cancel')}</span>
        </LoadingButton>
      </StyledStandardButtons>
      {children}
    </StyledDefaultFormButtons>
  );
};

export default DefaultFormButtons;
