import { baseApi as api } from '../baseApi.ts';

const injectedRtkApi = api.injectEndpoints({
  endpoints: (build) => ({
    getEnvironments: build.query<GetEnvironmentsApiResponse, GetEnvironmentsApiArg>({
      query: (queryArg) => ({ url: `/environments`, params: { limit: queryArg.limit, offset: queryArg.offset } }),
      providesTags: (result) =>
        result?.data
          ? [
              ...result.data.map(({ id }) => ({ type: 'Environments', id }) as const),
              { type: 'Environments', id: 'LIST' },
            ]
          : [{ type: 'Environments', id: 'LIST' }],
    }),
    postEnvironments: build.mutation<PostEnvironmentsApiResponse, PostEnvironmentsApiArg>({
      query: (queryArg) => ({ url: `/environments`, method: 'POST', body: queryArg.requestEnvironment }),
      invalidatesTags: () => [{ type: 'Environments', id: 'LIST' }],
    }),
    deleteEnvironmentsById: build.mutation<DeleteEnvironmentsByIdApiResponse, DeleteEnvironmentsByIdApiArg>({
      query: (queryArg) => ({ url: `/environments/${queryArg.id}`, method: 'DELETE' }),
      invalidatesTags: () => [{ type: 'Environments', id: 'LIST' }],
    }),
  }),
  overrideExisting: false,
});
export { injectedRtkApi as environmentsApi };
export type GetEnvironmentsApiResponse = /** status 200 OK */ ResponseEnvironmentsList;
export type GetEnvironmentsApiArg = {
  limit?: number;
  offset?: number;
};
export type PostEnvironmentsApiResponse = /** status 200 OK */ ResponseEnvironment;
export type PostEnvironmentsApiArg = {
  requestEnvironment: RequestEnvironment;
};
export type DeleteEnvironmentsByIdApiResponse = /** status 204 OK */ void;
export type DeleteEnvironmentsByIdApiArg = {
  id: number;
};
export type ResponseEnvironment = {
  id?: number;
  name?: string;
  description?: string | null;
  created_at?: string;
  updated_at?: string | null;
};
export type PaginationInfoForListRequests = {
  offset?: number | null;
  limit?: number | null;
  count?: number | null;
};
export type ResponseEnvironmentsList = {
  data?: ResponseEnvironment[];
  meta?: PaginationInfoForListRequests;
};
export type ErrorObject = {
  code?: number;
  title?: string;
  description?: string;
};
export type RequestEnvironment = {
  name?: string;
  description?: string;
};
export const {
  useGetEnvironmentsQuery,
  useLazyGetEnvironmentsQuery,
  usePostEnvironmentsMutation,
  useDeleteEnvironmentsByIdMutation,
} = injectedRtkApi;
