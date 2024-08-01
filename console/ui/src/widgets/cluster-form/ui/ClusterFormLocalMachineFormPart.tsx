import { FC } from 'react';
import DatabaseServersBlock from '@entities/database-servers-block';
import AuthenticationMethodFormBlock from '@entities/authentification-method-form-block';
import VipAddressBlock from '@entities/vip-address-block';
import LoadBalancersBlock from '@entities/load-balancers-block';

const ClusterFormLocalMachineFormPart: FC = () => (
  <>
    <DatabaseServersBlock />
    <AuthenticationMethodFormBlock />
    <VipAddressBlock />
    <LoadBalancersBlock />
  </>
);

export default ClusterFormLocalMachineFormPart;
