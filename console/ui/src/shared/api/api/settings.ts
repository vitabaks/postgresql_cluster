import { baseApi as api } from '../baseApi.ts';

const injectedRtkApi = api.injectEndpoints({
  endpoints: (build) => ({
    postSettings: build.mutation<PostSettingsApiResponse, PostSettingsApiArg>({
      query: (queryArg) => ({ url: `/settings`, method: 'POST', body: queryArg.requestCreateSetting }),
      invalidatesTags: () => [{ type: 'Settings', id: 'LIST' }],
    }),
    getSettings: build.query<GetSettingsApiResponse, GetSettingsApiArg>({
      query: (queryArg) => ({
        url: `/settings`,
        params: { name: queryArg.name, offset: queryArg.offset, limit: queryArg.limit },
      }),
      providesTags: (result) =>
        result?.data
          ? [...result.data.map(({ id }) => ({ type: 'Settings', id }) as const), { type: 'Settings', id: 'LIST' }]
          : [{ type: 'Settings', id: 'LIST' }],
    }),
    patchSettingsByName: build.mutation<PatchSettingsByNameApiResponse, PatchSettingsByNameApiArg>({
      query: (queryArg) => ({
        url: `/settings/${queryArg.name}`,
        method: 'PATCH',
        body: queryArg.requestChangeSetting,
      }),
      invalidatesTags: (result, error, { id }) => [{ type: 'Settings', id }],
    }),
  }),
  overrideExisting: false,
});
export { injectedRtkApi as settingsApi };
export type PostSettingsApiResponse = /** status 200 OK */ ResponseSetting;
export type PostSettingsApiArg = {
  requestCreateSetting: RequestCreateSetting;
};
export type GetSettingsApiResponse = /** status 200 OK */ ResponseSettings;
export type GetSettingsApiArg = {
  /** Filter by name */
  name?: string;
  offset?: number;
  limit?: number;
};
export type PatchSettingsByNameApiResponse = /** status 200 OK */ ResponseSetting;
export type PatchSettingsByNameApiArg = {
  name: string;
  requestChangeSetting: RequestChangeSetting;
};
export type ResponseSetting = {
  id?: number;
  name?: string;
  value?: object;
  created_at?: string;
  updated_at?: string | null;
};
export type ErrorObject = {
  code?: number;
  title?: string;
  description?: string;
};
export type RequestCreateSetting = {
  name?: string;
  value?: object;
};
export type PaginationInfoForListRequests = {
  offset?: number | null;
  limit?: number | null;
  count?: number | null;
};
export type ResponseSettings = {
  data?: ResponseSetting[];
  mete?: PaginationInfoForListRequests;
};
export type RequestChangeSetting = {
  value?: object | null;
};
export const { usePostSettingsMutation, useGetSettingsQuery, useLazyGetSettingsQuery, usePatchSettingsByNameMutation } =
  injectedRtkApi;
