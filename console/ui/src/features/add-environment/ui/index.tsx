import React, { FC } from 'react';
import { useTranslation } from 'react-i18next';
import { toast } from 'react-toastify';
import SettingsAddEntity from '@shared/ui/settings-add-entity/ui';
import { usePostEnvironmentsMutation } from '@shared/api/api/environments.ts';
import { AddEntityFormValues } from '@shared/ui/settings-add-entity/model/types.ts';
import { ADD_ENTITY_FORM_NAMES } from '@shared/ui/settings-add-entity/model/constants.ts';

const AddEnvironment: FC = () => {
  const { t } = useTranslation('settings');

  const [postEnvironmentTrigger, postEnvironmentTriggerState] = usePostEnvironmentsMutation();

  const onSubmit = async (values: AddEntityFormValues) => {
    await postEnvironmentTrigger({
      requestEnvironment: {
        name: values[ADD_ENTITY_FORM_NAMES.NAME],
        description: values[ADD_ENTITY_FORM_NAMES.DESCRIPTION],
      },
    }).unwrap();
    toast.success(
      t('environmentSuccessfullyCreated', {
        ns: 'toasts',
        environmentName: values[ADD_ENTITY_FORM_NAMES.NAME],
      }),
    );
  };

  return (
    <SettingsAddEntity
      buttonLabel={t('addEnvironment')}
      headerLabel={t('addEnvironment')}
      submitButtonLabel={t('addEnvironment')}
      nameLabel={t('environmentName')}
      isLoading={postEnvironmentTriggerState.isLoading}
      submitTrigger={onSubmit}
    />
  );
};

export default AddEnvironment;
