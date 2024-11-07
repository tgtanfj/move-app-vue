'use client';

import { endpointUser } from '@/helpers/enpoints';
import { baseApi } from '../base';

export const userAPI = baseApi.injectEndpoints({
  endpoints: (build) => ({
    getAllUsers: build.query({
      query: (params) => ({
        url: endpointUser.GET_ALL,
        params: {
          page: params.page,
          take: params.take,
          contentSearch: params.contentSearch || '',
          sortBy: params.sortBy || 'id',
          isAsc: params.isAsc ?? true,
          gender: params.gender || ''
        },
        method: 'GET',
        flashError: true
      })
    })
  })
});

export const { useGetAllUsersQuery } = userAPI;
