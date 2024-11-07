'use client';

import { endpointPayment } from '@/helpers/enpoints';
import { baseApi } from '../base';

export const paymentAPI = baseApi.injectEndpoints({
  endpoints: (build) => ({
    getAllPaymentHistories: build.query({
      query: (params) => ({
        url: endpointPayment.GET_PAYMENT_HISTORIES,
        params: {
          page: params.page,
          take: params.take,
          search: params.search || '',
          sortField: params.sortField || undefined,
          sortDirection: params.sortDirection || undefined,
          startDate: params.startDate,
          endDate: params.endDate,
          status: params.status || ''
        },
        method: 'GET',
        flashError: true
      })
    }),
    getAllWithdrawHistories: build.query({
      query: (params) => ({
        url: endpointPayment.GET_WITHDRAW_HISTORIES,
        params: {
          page: params.page,
          take: params.take,
          search: params.search || '',
          sortField: params.sortField || undefined,
          sortDirection: params.sortDirection || undefined,
          startDate: params.startDate,
          endDate: params.endDate,
          status: params.status || ''
        },
        method: 'GET',
        flashError: true
      })
    }),
    getRevenueEachUser: build.query({
      query: (params) => ({
        url: endpointPayment.GET_REVENUE_DATA,
        method: 'GET',
        params: {
          page: params.page,
          take: params.take,
          search: params.search || '',
          sortField: params.sortField || undefined,
          sortDirection: params.sortDirection || undefined
        },
        flashError: true
      })
    })
  })
});

export const {
  useGetAllPaymentHistoriesQuery,
  useGetAllWithdrawHistoriesQuery,
  useGetRevenueEachUserQuery
} = paymentAPI;
