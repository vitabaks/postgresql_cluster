import { PROJECTS_TABLE_COLUMN_NAMES } from '@widgets/projects-table/model/constants.ts';

export interface ProjectsTableValues {
  [PROJECTS_TABLE_COLUMN_NAMES.ID]: string;
  [PROJECTS_TABLE_COLUMN_NAMES.NAME]: string;
}
