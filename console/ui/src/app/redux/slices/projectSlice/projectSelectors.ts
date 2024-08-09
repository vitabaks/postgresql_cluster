import { RootState } from '@app/redux/store/store.ts';

export const selectCurrentProject = (state: RootState) => state.project.currentProject;
