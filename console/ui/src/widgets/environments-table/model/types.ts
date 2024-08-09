import { PROJECTS_TABLE_COLUMN_NAMES } from '@widgets/projects-table/model/constants.ts';

export interface EnvironmentTableValues {
  [PROJECTS_TABLE_COLUMN_NAMES.ID]: string;
  [PROJECTS_TABLE_COLUMN_NAMES.NAME]: string;
  [PROJECTS_TABLE_COLUMN_NAMES.DESCRIPTION]: 'description';
  [PROJECTS_TABLE_COLUMN_NAMES.CREATED]: 'created_at';
  [PROJECTS_TABLE_COLUMN_NAMES.UPDATED]: 'updated_at';
}
