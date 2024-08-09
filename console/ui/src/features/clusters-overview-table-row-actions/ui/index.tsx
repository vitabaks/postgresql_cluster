import { FC } from 'react';
import { useTranslation } from 'react-i18next';
import { handleRequestErrorCatch } from '@shared/lib/functions.ts';
import { ListItemIcon, MenuItem } from '@mui/material';
import { TableRowActionsProps } from '@shared/model/types.ts';
import { toast } from 'react-toastify';
import DeleteOutlineIcon from '@mui/icons-material/DeleteOutline';
import { useDeleteServersByIdMutation } from '@shared/api/api/other.ts';
import { CLUSTER_OVERVIEW_TABLE_COLUMN_NAMES } from '@widgets/cluster-overview-table/model/constants.ts';
import { useLazyGetClustersByIdQuery } from '@shared/api/api/clusters.ts';
import { useParams } from 'react-router-dom';

const ClustersOverviewTableRowActions: FC<TableRowActionsProps> = ({ closeMenu, row }) => {
  const { t } = useTranslation(['shared', 'toasts']);
  const { clusterId } = useParams();

  const [removeServerTrigger] = useDeleteServersByIdMutation();
  const [getClusterTrigger] = useLazyGetClustersByIdQuery();

  const handleButtonClick = async () => {
    try {
      await removeServerTrigger({ id: row.original[CLUSTER_OVERVIEW_TABLE_COLUMN_NAMES.ID] }).unwrap();
      toast.success(
        t('serverSuccessfullyRemoved', {
          ns: 'toasts',
          serverName: row.original[CLUSTER_OVERVIEW_TABLE_COLUMN_NAMES.NAME],
        }),
      );
      await getClusterTrigger({ id: clusterId });
    } catch (e) {
      handleRequestErrorCatch(e);
    } finally {
      closeMenu();
    }
  };

  return [
    <MenuItem key={0} onClick={handleButtonClick} sx={{ m: 0 }}>
      <ListItemIcon>
        <DeleteOutlineIcon />
      </ListItemIcon>
      {t('removeFromList', { ns: 'shared' })}
    </MenuItem>,
  ];
};

export default ClustersOverviewTableRowActions;
