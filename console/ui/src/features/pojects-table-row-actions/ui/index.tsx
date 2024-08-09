import { FC } from 'react';
import { ListItemIcon, MenuItem } from '@mui/material';
import DeleteOutlineIcon from '@mui/icons-material/DeleteOutline';
import { useTranslation } from 'react-i18next';
import { useDeleteProjectsByIdMutation } from '@shared/api/api/projects.ts';
import { toast } from 'react-toastify';
import { handleRequestErrorCatch } from '@shared/lib/functions.ts';
import { TableRowActionsProps } from '@shared/model/types.ts';
import { PROJECTS_TABLE_COLUMN_NAMES } from '@widgets/projects-table/model/constants.ts';
import { useAppSelector } from '@app/redux/store/hooks.ts';
import { selectCurrentProject } from '@app/redux/slices/projectSlice/projectSelectors.ts';

const ProjectsTableRowActions: FC<TableRowActionsProps> = ({ closeMenu, row }) => {
  const { t } = useTranslation(['shared', 'toasts']);

  const currentProject = useAppSelector(selectCurrentProject);

  const [removeProjectTrigger] = useDeleteProjectsByIdMutation();

  const handleButtonClick = async () => {
    try {
      if (Number(currentProject) === row.original[PROJECTS_TABLE_COLUMN_NAMES.ID])
        throw t('cannotRemoveActiveProject', { ns: 'toasts' });
      await removeProjectTrigger({ id: row.original[PROJECTS_TABLE_COLUMN_NAMES.ID] }).unwrap();
      toast.success(
        t('projectSuccessfullyRemoved', {
          ns: 'toasts',
          projectName: row.original[PROJECTS_TABLE_COLUMN_NAMES.NAME],
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

export default ProjectsTableRowActions;
