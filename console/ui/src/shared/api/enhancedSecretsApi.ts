import { secretsApi } from '@shared/api/api/secrets.ts';

const enhancedSecretsApi = secretsApi.enhanceEndpoints({
  addTagTypes: ['Secrets'],
  endpoints: {
    getSecrets: {
      providesTags: ['Secrets'],
    },
    postSecrets: {
      invalidatesTags: ['Secrets'],
    },
  },
});

export default enhancedSecretsApi;
