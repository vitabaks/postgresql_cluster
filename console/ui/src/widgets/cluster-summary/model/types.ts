import { ReactElement } from 'react';
import { CLUSTER_FORM_FIELD_NAMES } from '@widgets/cluster-form/model/constants.ts';

export interface SharedClusterSummaryProps {
  [CLUSTER_FORM_FIELD_NAMES.CLUSTER_NAME]: string;
  [CLUSTER_FORM_FIELD_NAMES.POSTGRES_VERSION]: number;
}

export interface CloudProviderClustersSummary extends SharedClusterSummaryProps {
  [CLUSTER_FORM_FIELD_NAMES.PROVIDER]: {
    icon: ReactElement;
    name: string;
  };
  [CLUSTER_FORM_FIELD_NAMES.REGION_CONFIG]: {
    name: string;
    place: string;
  };
  [CLUSTER_FORM_FIELD_NAMES.INSTANCE_CONFIG]: {
    name: string;
    cpu: number;
    ram: number;
  };
  [CLUSTER_FORM_FIELD_NAMES.INSTANCES_AMOUNT]: number;
  [CLUSTER_FORM_FIELD_NAMES.STORAGE_AMOUNT]: number;
  [CLUSTER_FORM_FIELD_NAMES.INSTANCE_CONFIG]: number;
  [CLUSTER_FORM_FIELD_NAMES.INSTANCES_AMOUNT]: number;
}

export interface LocalClustersSummary extends SharedClusterSummaryProps {
  [CLUSTER_FORM_FIELD_NAMES.DATABASE_SERVERS]: number;
  [CLUSTER_FORM_FIELD_NAMES.IS_HAPROXY_LOAD_BALANCER]: boolean;
}

export interface UseGetSummaryConfigProps {
  isCloudProvider: boolean;
  data: CloudProviderClustersSummary | LocalClustersSummary;
}
