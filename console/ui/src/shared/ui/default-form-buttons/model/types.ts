import { ReactElement } from 'react';

export interface DefaultFormButtonsProps {
  isDisabled?: boolean;
  isSubmitting?: boolean;
  submitButtonLabel?: string;
  cancelButtonLabel?: string;
  cancelHandler: () => void;
  children?: ReactElement;
}
