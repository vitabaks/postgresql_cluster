import { FC } from 'react';
import { TableRowActionsProps } from '@shared/model/types.ts';
import { useTranslation } from 'react-i18next';
import { toast } from 'react-toastify';
import { handleRequestErrorCatch } from '@shared/lib/functions.ts';
import { ListItemIcon, MenuItem } from '@mui/material';
import DeleteOutlineIcon from '@mui/icons-material/DeleteOutline';
import { useDeleteEnvironmentsByIdMutation } from '@shared/api/api/environments.ts';
import { ENVIRONMENTS_TABLE_COLUMN_NAMES } from '@widgets/environments-table/model/constants.ts';

const EnvironmentsTableRowActions: FC<TableRowActionsProps> = ({ closeMenu, row }) => {
  const { t } = useTranslation(['shared', 'toasts']);

  const [removeEnvironmentTrigger] = useDeleteEnvironmentsByIdMutation();

  const handleButtonClick = async () => {
    try {
      await removeEnvironmentTrigger({ id: row.original[ENVIRONMENTS_TABLE_COLUMN_NAMES.ID] }).unwrap();
      toast.success(
        t('environmentSuccessfullyRemoved', {
          ns: 'toasts',
          environmentName: row.original[ENVIRONMENTS_TABLE_COLUMN_NAMES.NAME],
        }),
      );
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

export default EnvironmentsTableRowActions;
