import { FC } from 'react';
import ClusterFormRegionBlock from '@entities/cluster-form-cloud-region-block';
import ClusterFormInstancesBlock from '@entities/cluster-form-instances-block';
import InstancesAmountBlock from '@entities/cluster-form-instances-amount-block';
import StorageBlock from '@entities/storage-block';
import ClusterFormSshKeyBlock from '@entities/ssh-key-block';

const ClusterFormCloudProviderFormPart: FC = () => (
  <>
    <ClusterFormRegionBlock />
    <ClusterFormInstancesBlock />
    <InstancesAmountBlock />
    <StorageBlock />
    <ClusterFormSshKeyBlock />
  </>
);

export default ClusterFormCloudProviderFormPart;
