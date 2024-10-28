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
    })
  })
});

export const {
  useGetAllPaymentHistoriesQuery,
  useGetAllWithdrawHistoriesQuery
} = paymentAPI;
