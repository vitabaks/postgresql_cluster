import { baseApi as api } from '../baseApi.ts';

const injectedRtkApi = api.injectEndpoints({
  endpoints: (build) => ({
    getVersion: build.query<GetVersionApiResponse, GetVersionApiArg>({
      query: () => ({ url: `/version` }),
    }),
    getDatabaseExtensions: build.query<GetDatabaseExtensionsApiResponse, GetDatabaseExtensionsApiArg>({
      query: (queryArg) => ({
        url: `/database/extensions`,
        params: {
          offset: queryArg.offset,
          limit: queryArg.limit,
          extension_type: queryArg.extensionType,
          postgres_version: queryArg.postgresVersion,
        },
      }),
    }),
    getPostgresVersions: build.query<GetPostgresVersionsApiResponse, GetPostgresVersionsApiArg>({
      query: () => ({ url: `/postgres_versions` }),
    }),
    deleteServersById: build.mutation<DeleteServersByIdApiResponse, DeleteServersByIdApiArg>({
      query: (queryArg) => ({ url: `/servers/${queryArg.id}`, method: 'DELETE' }),
    }),
  }),
  overrideExisting: false,
});
export { injectedRtkApi as otherApi };
export type GetVersionApiResponse = /** status 200 OK */ VersionResponse;
export type GetVersionApiArg = void;
export type GetDatabaseExtensionsApiResponse = /** status 200 OK */ ResponseDatabaseExtensions;
export type GetDatabaseExtensionsApiArg = {
  offset?: number;
  limit?: number;
  extensionType?: 'all' | 'contrib' | 'third_party';
  postgresVersion?: string;
};
export type GetPostgresVersionsApiResponse = /** status 200 OK */ ResponsePostgresVersions;
export type GetPostgresVersionsApiArg = void;
export type DeleteServersByIdApiResponse = /** status 204 OK */ void;
export type DeleteServersByIdApiArg = {
  id: number;
};
export type VersionResponse = {
  version?: string;
};
export type ResponseDatabaseExtension = {
  name?: string;
  description?: string | null;
  url?: string | null;
  image?: string | null;
  postgres_min_version?: string | null;
  postgres_max_version?: string | null;
  contrib?: boolean;
};
export type PaginationInfoForListRequests = {
  offset?: number | null;
  limit?: number | null;
  count?: number | null;
};
export type ResponseDatabaseExtensions = {
  data?: ResponseDatabaseExtension[];
  meta?: PaginationInfoForListRequests;
};
export type ErrorObject = {
  code?: number;
  title?: string;
  description?: string;
};
export type ResponsePostgresVersion = {
  major_version?: number;
  release_date?: string;
  end_of_life?: string;
};
export type ResponsePostgresVersions = {
  data?: ResponsePostgresVersion[];
};
export const {
  useGetVersionQuery,
  useLazyGetVersionQuery,
  useGetDatabaseExtensionsQuery,
  useLazyGetDatabaseExtensionsQuery,
  useGetPostgresVersionsQuery,
  useLazyGetPostgresVersionsQuery,
  useDeleteServersByIdMutation,
} = injectedRtkApi;
