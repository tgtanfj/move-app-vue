'use client';

import { endpointVideo } from '@/helpers/enpoints';
import { baseApi } from '../base';

export const videosAPI = baseApi.injectEndpoints({
  endpoints: (build) => ({
    getAllVideos: build.query<
      any,
      {
        page: number;
        take: number;
        query?: string;
        sortBy?: string;
        workoutLevel?: string;
      }
    >({
      query: (params) => ({
        url: endpointVideo.GET_ALL,
        params: {
          page: params.page,
          take: params.take,
          query: params.query || undefined,
          sortBy: params.sortBy || undefined,
          workoutLevel: params.workoutLevel || undefined
        },
        method: 'GET',
        flashError: true
      })
    })
  })
});

export const { useGetAllVideosQuery } = videosAPI;
