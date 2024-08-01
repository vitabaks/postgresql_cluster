import { ADD_ENTITY_FORM_NAMES } from '@shared/ui/settings-add-entity/model/constants.ts';

export interface AddEntityFormValues {
  [ADD_ENTITY_FORM_NAMES.NAME]: string;
  [ADD_ENTITY_FORM_NAMES.NAME]: string;
}

export interface SettingsAddEntityProps {
  buttonLabel: string;
  submitButtonLabel: string;
  isLoading?: boolean;
  submitTrigger: (values: AddEntityFormValues) => void;
}
