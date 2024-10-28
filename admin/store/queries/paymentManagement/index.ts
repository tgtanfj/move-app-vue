'use client';

import { endpointPayment } from '@/helpers/enpoints';
import { baseApi } from '../base';

export const paymentAPI = baseApi.injectEndpoints({
  endpoints: (build) => ({
    getAllPaymentHistories: build.query({
      query: () => ({
        url: endpointPayment.GET_PAYMENT_HISTORIES,
        method: 'GET',
        flashError: true
      })
    }),
    getAllWithdrawHistories: build.query({
      query: () => ({
        url: endpointPayment.GET_WITHDRAW_HISTORIES,
        method: 'GET',
        flashError: true
      })
    }),
    getBalance: build.query({
      query: () => ({
        url: endpointPayment.GET_BALANCE,
        method: 'GET',
        flashError: true
      })
    }),
    getRevenueEachUser: build.query({
      query: () => ({
        url: endpointPayment.GET_REVENUE_DATA,
        method: 'GET',
        flashError: true
      })
    }),
    getTotalRevenue: build.query({
      query: () => ({
        url: endpointPayment.GET_TOTAL_REVENUE,
        method: 'GET',
        flashError: true
      })
    }),
    getTotalWithdraw: build.query({
      query: () => ({
        url: endpointPayment.GET_TOTAL_WITHDRAW,
        method: 'GET',
        flashError: true
      })
    })
  })
});

export const {
  useGetAllPaymentHistoriesQuery,
  useGetAllWithdrawHistoriesQuery,
  useGetBalanceQuery,
  useGetRevenueEachUserQuery,
  useGetTotalRevenueQuery,
  useGetTotalWithdrawQuery
} = paymentAPI;
