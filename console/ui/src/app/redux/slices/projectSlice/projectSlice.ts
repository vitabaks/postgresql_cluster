import { createSlice, PayloadAction } from '@reduxjs/toolkit';

interface ProjectSliceState {
  currentProject: string | null;
}

const initialState: ProjectSliceState = {
  currentProject: localStorage.getItem('currentProject') ?? '',
};

export const projectSlice = createSlice({
  name: 'project',
  initialState,
  reducers: {
    setProject: (state: ProjectSliceState, action: PayloadAction<string>) => {
      state.currentProject = action.payload;
      localStorage.setItem('currentProject', action.payload);
    },
  },
});

export const { setProject } = projectSlice.actions;

export default projectSlice.reducer;
