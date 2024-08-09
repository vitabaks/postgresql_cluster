import { baseApi as api } from '../baseApi.ts';

const injectedRtkApi = api.injectEndpoints({
  endpoints: (build) => ({
    postSecrets: build.mutation<PostSecretsApiResponse, PostSecretsApiArg>({
      query: (queryArg) => ({ url: `/secrets`, method: 'POST', body: queryArg.requestSecretCreate }),
      invalidatesTags: () => [{ type: 'Secrets', id: 'LIST' }],
    }),
    getSecrets: build.query<GetSecretsApiResponse, GetSecretsApiArg>({
      query: (queryArg) => ({
        url: `/secrets`,
        params: {
          limit: queryArg.limit,
          offset: queryArg.offset,
          project_id: queryArg.projectId,
          name: queryArg.name,
          type: queryArg.type,
          sort_by: queryArg.sortBy,
        },
      }),
      providesTags: (result) =>
        result?.data
          ? [...result.data.map(({ id }) => ({ type: 'Secrets', id }) as const), { type: 'Secrets', id: 'LIST' }]
          : [{ type: 'Secrets', id: 'LIST' }],
    }),
    patchSecretsById: build.mutation<PatchSecretsByIdApiResponse, PatchSecretsByIdApiArg>({
      query: (queryArg) => ({ url: `/secrets/${queryArg.id}`, method: 'PATCH', body: queryArg.requestSecretPatch }),
      invalidatesTags: (result, error, { id }) => [{ type: 'Secrets', id }],
    }),
    deleteSecretsById: build.mutation<DeleteSecretsByIdApiResponse, DeleteSecretsByIdApiArg>({
      query: (queryArg) => ({ url: `/secrets/${queryArg.id}`, method: 'DELETE' }),
      invalidatesTags: () => [{ type: 'Secrets', id: 'LIST' }],
    }),
  }),
  overrideExisting: false,
});
export { injectedRtkApi as secretsApi };
export type PostSecretsApiResponse = /** status 200 OK */ ResponseSecretInfo;

export interface PostSecretsApiArg {
  requestSecretCreate: RequestSecretCreate;
}

export type GetSecretsApiResponse = /** status 200 OK */ ResponseSecretInfoList;

export interface GetSecretsApiArg {
  limit?: number;
  offset?: number;
  projectId: number;
  /** Filter by name */
  name?: string;
  /** Filter by type */
  type?: string;
  /** Sort by fields. Example: sort_by=id,name,-type */
  sortBy?: string;
}

export type PatchSecretsByIdApiResponse = /** status 200 OK */ ResponseSecretInfo;

export interface PatchSecretsByIdApiArg {
  id: number;
  requestSecretPatch: RequestSecretPatch;
}

export type DeleteSecretsByIdApiResponse = /** status 204 OK */ void;

export interface DeleteSecretsByIdApiArg {
  id: number;
}

export type SecretType = 'aws' | 'gcp' | 'hetzner' | 'ssh_key' | 'digitalocean' | 'password' | 'azure';

export interface ResponseSecretInfo {
  id?: number;
  project_id?: number;
  name?: string;
  type?: SecretType;
  created_at?: string;
  updated_at?: string | null;
  is_used?: boolean;
  used_by_clusters?: string | null;
}

export interface ErrorObject {
  code?: number;
  title?: string;
  description?: string;
}

export interface RequestSecretValueAws {
  AWS_ACCESS_KEY_ID?: string;
  AWS_SECRET_ACCESS_KEY?: string;
}

export interface RequestSecretValueGcp {
  GCP_SERVICE_ACCOUNT_CONTENTS?: string;
}

export interface RequestSecretValueHetzner {
  HCLOUD_API_TOKEN?: string;
}

export interface RequestSecretValueSshKey {
  SSH_PRIVATE_KEY?: string;
}

export interface RequestSecretValueDigitalOcean {
  DO_API_TOKEN?: string;
}

export interface RequestSecretValuePassword {
  USERNAME?: string;
  PASSWORD?: string;
}

export interface RequestSecretValueAzure {
  AZURE_SUBSCRIPTION_ID?: string;
  AZURE_CLIENT_ID?: string;
  AZURE_SECRET?: string;
  AZURE_TENANT?: string;
}

export interface RequestSecretValue {
  aws?: RequestSecretValueAws;
  gcp?: RequestSecretValueGcp;
  hetzner?: RequestSecretValueHetzner;
  ssh_key?: RequestSecretValueSshKey;
  digitalocean?: RequestSecretValueDigitalOcean;
  password?: RequestSecretValuePassword;
  azure?: RequestSecretValueAzure;
}

export interface RequestSecretCreate {
  project_id?: number;
  name?: string;
  type?: SecretType;
  value?: RequestSecretValue;
}

export interface PaginationInfoForListRequests {
  offset?: number | null;
  limit?: number | null;
  count?: number | null;
}

export interface ResponseSecretInfoList {
  data?: ResponseSecretInfo[];
  meta?: PaginationInfoForListRequests;
}

export interface RequestSecretPatch {
  name?: string | null;
  type?: string | null;
  /** Secret value in base64 */
  value?: string | null;
}

export const {
  usePostSecretsMutation,
  useGetSecretsQuery,
  useLazyGetSecretsQuery,
  usePatchSecretsByIdMutation,
  useDeleteSecretsByIdMutation,
} = injectedRtkApi;
