import { CLUSTER_FORM_FIELD_NAMES } from '@widgets/cluster-form/model/constants.ts';

export interface ClusterFormRegionConfigBoxProps {
  name: string;
  place: string;
  isActive: boolean;
}

export interface ClusterDatabaseServer {
  [CLUSTER_FORM_FIELD_NAMES.HOSTNAME]: string;
  [CLUSTER_FORM_FIELD_NAMES.IP_ADDRESS]: string;
  [CLUSTER_FORM_FIELD_NAMES.LOCATION]: string;
}
