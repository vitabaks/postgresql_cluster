import { TFunction } from 'i18next';
import * as yup from 'yup';
import { ADD_ENTITY_FORM_NAMES } from '@shared/ui/settings-add-entity/model/constants.ts';

export const AddEntityFormSchema = (t: TFunction) =>
  yup.object({
    [ADD_ENTITY_FORM_NAMES.NAME]: yup.string().required(t('requiredField', { ns: 'validation' })),
    [ADD_ENTITY_FORM_NAMES.DESCRIPTION]: yup.string(),
  });
