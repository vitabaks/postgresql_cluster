import { TFunction } from 'i18next';
import { AUTHENTICATION_METHODS } from '@shared/model/constants.ts';

export const authenticationMethods = (t: TFunction) =>
  Object.freeze([
    {
      id: AUTHENTICATION_METHODS.SSH,
      name: t('sshKey', { ns: 'clusters' }),
      description: t('sshKeyAuthDescription', { ns: 'clusters' }),
    },
    {
      id: AUTHENTICATION_METHODS.PASSWORD,
      name: t('password', { ns: 'shared' }),
      description: t('passwordAuthDescription', { ns: 'clusters' }),
    },
  ]);
