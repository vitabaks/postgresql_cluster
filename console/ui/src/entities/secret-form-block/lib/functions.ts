import { PROVIDERS } from '@shared/config/constants.ts';
import AwsSecretBlock from '@entities/secret-form-block/ui/AwsSecret.tsx';
import GcpSecretBlock from '@entities/secret-form-block/ui/GcpSecret.tsx';
import AzureSecretBlock from '@entities/secret-form-block/ui/AzureSecret.tsx';
import DoSecretBlock from '@entities/secret-form-block/ui/DigitalOceanSecret.tsx';
import HetznerSecretBlock from '@entities/secret-form-block/ui/HetznerSecret.tsx';
import SshKeySecretBlock from '@entities/secret-form-block/ui/SshKeySecret.tsx';
import PasswordSecretBlock from '@entities/secret-form-block/ui/PasswordSecret.tsx';
import { AUTHENTICATION_METHODS } from '@shared/model/constants.ts';
import { SecretFormValues } from '@entities/secret-form-block/model/types.ts';
import { SECRET_MODAL_CONTENT_FORM_FIELD_NAMES } from '@entities/secret-form-block/model/constants.ts';

export const getAddSecretFormContentByType = (type: string) => {
  switch (type) {
    case PROVIDERS.AWS:
      return {
        translationKey: 'settingsAwsSecretInfo',
        link: 'https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html',
        formComponent: AwsSecretBlock,
      };
    case PROVIDERS.GCP:
      return {
        translationKey: 'settingsGcpSecretInfo',
        link: 'https://cloud.google.com/iam/docs/keys-create-delete',
        formComponent: GcpSecretBlock,
      };
    case PROVIDERS.AZURE:
      return {
        translationKey: 'settingsAzureSecretInfo',
        link: 'https://learn.microsoft.com/en-us/azure/developer/ansible/create-ansible-service-principal?tabs=azure-cli',
        formComponent: AzureSecretBlock,
      };
    case PROVIDERS.DIGITAL_OCEAN:
      return {
        translationKey: 'settingsDoSecretInfo',
        link: 'https://docs.digitalocean.com/reference/api/create-personal-access-token/',
        formComponent: DoSecretBlock,
      };
    case PROVIDERS.HETZNER:
      return {
        translationKey: 'settingsHetznerSecretInfo',
        link: 'https://docs.hetzner.com/cloud/api/getting-started/generating-api-token/',
        formComponent: HetznerSecretBlock,
      };
    case AUTHENTICATION_METHODS.SSH:
      return {
        translationKey: 'settingsSshKeySecretInfo',
        formComponent: SshKeySecretBlock,
      };
    default:
      return {
        translationKey: 'settingsPasswordSecretInfo',
        formComponent: PasswordSecretBlock,
      };
  }
};

export const getSecretBodyFromValues = (values: SecretFormValues) => {
  switch (values[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.SECRET_TYPE]) {
    case PROVIDERS.AWS:
      return {
        [PROVIDERS.AWS]: {
          [SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AWS_ACCESS_KEY_ID]:
            values[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AWS_ACCESS_KEY_ID],
          [SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AWS_SECRET_ACCESS_KEY]:
            values[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AWS_SECRET_ACCESS_KEY],
        },
      };
    case PROVIDERS.GCP:
      return {
        [PROVIDERS.GCP]: {
          [SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.GCP_SERVICE_ACCOUNT_CONTENTS]:
            values[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.GCP_SERVICE_ACCOUNT_CONTENTS],
        },
      };
    case PROVIDERS.DIGITAL_OCEAN:
      return {
        [PROVIDERS.DIGITAL_OCEAN]: {
          [SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.DO_API_TOKEN]:
            values[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.DO_API_TOKEN],
        },
      };
    case PROVIDERS.AZURE:
      return {
        [PROVIDERS.AZURE]: {
          [SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AZURE_SUBSCRIPTION_ID]:
            values[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AZURE_SUBSCRIPTION_ID],
          [SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AZURE_CLIENT_ID]:
            values[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AZURE_CLIENT_ID],
          [SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AZURE_SECRET]:
            values[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AZURE_SECRET],
          [SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AZURE_TENANT]:
            values[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.AZURE_TENANT],
        },
      };
    case PROVIDERS.HETZNER:
      return {
        [PROVIDERS.HETZNER]: {
          [SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.HCLOUD_API_TOKEN]:
            values[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.HCLOUD_API_TOKEN],
        },
      };
    case AUTHENTICATION_METHODS.SSH:
      return {
        [AUTHENTICATION_METHODS.SSH]: {
          [SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.SSH_PRIVATE_KEY]:
            values[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.SSH_PRIVATE_KEY],
        },
      };
    case AUTHENTICATION_METHODS.PASSWORD:
      return {
        [AUTHENTICATION_METHODS.PASSWORD]: {
          [SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.USERNAME]: values[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.USERNAME],
          [SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.PASSWORD]: values[SECRET_MODAL_CONTENT_FORM_FIELD_NAMES.PASSWORD],
        },
      };
  }
};
