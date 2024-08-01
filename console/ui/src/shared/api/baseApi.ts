import { createApi, fetchBaseQuery } from '@reduxjs/toolkit/query/react';
import { API_URL } from '@shared/config/constants.ts';
import i18n from 'i18next';

export const baseApi = createApi({
  baseQuery: fetchBaseQuery({
    baseUrl: API_URL as string,
    prepareHeaders: (headers, { endpoint }) => {
      headers.set('Accept-Language', i18n.language);
      if (endpoint !== 'login') headers.set('Authorization', `Bearer ${String(localStorage.getItem('token'))}`);
      return headers;
    },
  }),
  tagTypes: ['Clusters', 'Operations', 'Secrets', 'Projects', 'Environments', 'Settings'],
  endpoints: () => ({}),
});
