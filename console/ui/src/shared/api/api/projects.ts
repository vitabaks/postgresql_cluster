import { baseApi as api } from '../baseApi.ts';

const injectedRtkApi = api.injectEndpoints({
  endpoints: (build) => ({
    postProjects: build.mutation<PostProjectsApiResponse, PostProjectsApiArg>({
      query: (queryArg) => ({ url: `/projects`, method: 'POST', body: queryArg.requestProjectCreate }),
      invalidatesTags: () => [{ type: 'Projects', id: 'LIST' }],
    }),
    getProjects: build.query<GetProjectsApiResponse, GetProjectsApiArg>({
      query: (queryArg) => ({ url: `/projects`, params: { limit: queryArg.limit, offset: queryArg.offset } }),
      providesTags: (result) =>
        result?.data
          ? [...result.data.map(({ id }) => ({ type: 'Projects', id }) as const), { type: 'Projects', id: 'LIST' }]
          : [{ type: 'Projects', id: 'LIST' }],
    }),
    patchProjectsById: build.mutation<PatchProjectsByIdApiResponse, PatchProjectsByIdApiArg>({
      query: (queryArg) => ({ url: `/projects/${queryArg.id}`, method: 'PATCH', body: queryArg.requestProjectPatch }),
      invalidatesTags: (result, error, { id }) => [{ type: 'Projects', id }],
    }),
    deleteProjectsById: build.mutation<DeleteProjectsByIdApiResponse, DeleteProjectsByIdApiArg>({
      query: (queryArg) => ({ url: `/projects/${queryArg.id}`, method: 'DELETE' }),
      invalidatesTags: () => [{ type: 'Projects', id: 'LIST' }],
    }),
  }),
  overrideExisting: false,
});
export { injectedRtkApi as projectsApi };
export type PostProjectsApiResponse = /** status 200 OK */ ResponseProject;
export type PostProjectsApiArg = {
  requestProjectCreate: RequestProjectCreate;
};
export type GetProjectsApiResponse = /** status 200 OK */ ResponseProjectsList;
export type GetProjectsApiArg = {
  limit?: number;
  offset?: number;
};
export type PatchProjectsByIdApiResponse = /** status 200 OK */ ResponseProject;
export type PatchProjectsByIdApiArg = {
  id: number;
  requestProjectPatch: RequestProjectPatch;
};
export type DeleteProjectsByIdApiResponse = /** status 204 OK */ void;
export type DeleteProjectsByIdApiArg = {
  id: number;
};
export type ResponseProject = {
  id?: number;
  name?: string;
  description?: string | null;
  created_at?: string;
  updated_at?: string | null;
};
export type ErrorObject = {
  code?: number;
  title?: string;
  description?: string;
};
export type RequestProjectCreate = {
  name?: string;
  description?: string;
};
export type PaginationInfoForListRequests = {
  offset?: number | null;
  limit?: number | null;
  count?: number | null;
};
export type ResponseProjectsList = {
  data?: ResponseProject[];
  meta?: PaginationInfoForListRequests;
};
export type RequestProjectPatch = {
  name?: string | null;
  description?: string | null;
};
export const {
  usePostProjectsMutation,
  useGetProjectsQuery,
  useLazyGetProjectsQuery,
  usePatchProjectsByIdMutation,
  useDeleteProjectsByIdMutation,
} = injectedRtkApi;
