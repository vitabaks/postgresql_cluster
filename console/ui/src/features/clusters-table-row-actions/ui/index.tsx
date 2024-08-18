import { FC } from 'react';
import { TableRowActionsProps } from '@shared/model/types.ts';
import ClustersTableRemoveButton from '@features/clusters-table-row-actions/ui/ClusterTableRemoveButton.tsx';

const ClustersTableRowActions: FC<TableRowActionsProps> = ({ closeMenu, row }) => [
  <ClustersTableRemoveButton
    key={0}
    clusterId={row.original.id}
    clusterName={row.original.name.props.children}
    closeMenu={closeMenu}
  />,
];

export default ClustersTableRowActions;
