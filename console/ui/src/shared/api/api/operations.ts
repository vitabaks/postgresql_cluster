import { baseApi as api } from '../baseApi.ts';

const injectedRtkApi = api.injectEndpoints({
  endpoints: (build) => ({
    getOperations: build.query<GetOperationsApiResponse, GetOperationsApiArg>({
      query: (queryArg) => ({
        url: `/operations`,
        params: {
          project_id: queryArg.projectId,
          start_date: queryArg.startDate,
          end_date: queryArg.endDate,
          cluster_name: queryArg.clusterName,
          type: queryArg['type'],
          status: queryArg.status,
          sort_by: queryArg.sortBy,
          limit: queryArg.limit,
          offset: queryArg.offset,
        },
      }),
      providesTags: (result) =>
        result?.data
          ? [...result.data.map(({ id }) => ({ type: 'Operations', id }) as const), { type: 'Operations', id: 'LIST' }]
          : [{ type: 'Operations', id: 'LIST' }],
    }),
    getOperationsByIdLog: build.query<GetOperationsByIdLogApiResponse, GetOperationsByIdLogApiArg>({
      query: (queryArg) => ({ url: `/operations/${queryArg.id}/log` }),
      transformResponse: (response, meta) => ({
        log: response,
        isComplete: meta.response.headers.get('x-log-completed')?.toString() === 'true',
      }),
      providesTags: (result, error, { id }) => [{ type: 'Operations', id }],
    }),
  }),
  overrideExisting: false,
});
export { injectedRtkApi as operationsApi };
export type GetOperationsApiResponse = /** status 200 OK */ ResponseOperationsList;
export type GetOperationsApiArg = {
  /** Required parameter for filter */
  projectId: number;
  /** Operations started after this date */
  startDate: string;
  /** Operations started till this date */
  endDate: string;
  /** Filter by cluster_name */
  clusterName?: string;
  /** Filter by type */
  type?: string;
  /** Filter by status */
  status?: string;
  /** Sort by fields. Example: sort_by=cluster_name,-type,status,id */
  sortBy?: string;
  limit?: number;
  offset?: number;
};
export type GetOperationsByIdLogApiResponse = /** status 200 OK */ string;
export type GetOperationsByIdLogApiArg = {
  /** Operation id */
  id: number;
};
export type ResponseOperation = {
  id?: number;
  cluster_name?: string;
  started?: string;
  finished?: string | null;
  type?: string;
  status?: string;
  environment?: string;
};
export type PaginationInfoForListRequests = {
  offset?: number | null;
  limit?: number | null;
  count?: number | null;
};
export type ResponseOperationsList = {
  data?: ResponseOperation[];
  meta?: PaginationInfoForListRequests;
};
export type ErrorObject = {
  code?: number;
  title?: string;
  description?: string;
};
export const {
  useGetOperationsQuery,
  useLazyGetOperationsQuery,
  useGetOperationsByIdLogQuery,
  useLazyGetOperationsByIdLogQuery,
} = injectedRtkApi;
