import * as yup from 'yup';
import { TFunction } from 'i18next';
import { PROJECT_FORM_NAMES } from '@features/add-project/model/constants.ts';

export const AddProjectFormSchema = (t: TFunction) =>
  yup.object({
    [PROJECT_FORM_NAMES.NAME]: yup.string().required(t('requiredField', { ns: 'validation' })),
    [PROJECT_FORM_NAMES.DESCRIPTION]: yup.string(),
  });
