import { FC } from 'react';
import { useTranslation } from 'react-i18next';
import { ListItemIcon, MenuItem } from '@mui/material';
import { useDeleteSecretsByIdMutation } from '@shared/api/api/secrets.ts';
import { TableRowActionsProps } from '@shared/model/types.ts';
import DeleteOutlineIcon from '@mui/icons-material/DeleteOutline';
import { toast } from 'react-toastify';
import { handleRequestErrorCatch } from '@shared/lib/functions.ts';
import { SECRETS_TABLE_COLUMN_NAMES } from '@widgets/secrets-table/model/constants.ts';
import { SECRET_TOAST_DISPLAY_CLUSTERS_LIMIT } from '@features/settings-table-row-actions/model/constants.ts';

const SettingsTableRowActions: FC<TableRowActionsProps> = ({ closeMenu, row }) => {
  const { t } = useTranslation(['shared', 'toasts']);

  const [removeSecretTrigger] = useDeleteSecretsByIdMutation();

  const handleButtonClick = async () => {
    try {
      if (row.original[SECRETS_TABLE_COLUMN_NAMES.USED].toString() === 'true') {
        const usingClusterList = row.original[SECRETS_TABLE_COLUMN_NAMES.USED_BY]?.split(', ');
        toast.warning(
          t('secretsSecretIsUsed', {
            ns: 'toasts',
            count: usingClusterList?.length,
            clusterNames:
              usingClusterList?.length > SECRET_TOAST_DISPLAY_CLUSTERS_LIMIT
                ? `${[...usingClusterList.slice(0, SECRET_TOAST_DISPLAY_CLUSTERS_LIMIT), '...'].join(', ')}`
                : row.original[SECRETS_TABLE_COLUMN_NAMES.USED_BY],
          }),
        );
      } else {
        await removeSecretTrigger({ id: row.original[SECRETS_TABLE_COLUMN_NAMES.ID] }).unwrap();
        toast.success(
          t('secretSuccessfullyRemoved', {
            ns: 'toasts',
            secretName: row.original[SECRETS_TABLE_COLUMN_NAMES.NAME],
          }),
        );
      }
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
      {t('delete')}
    </MenuItem>,
  ];
};

export default SettingsTableRowActions;
