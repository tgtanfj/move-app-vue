import { useQuery } from '@tanstack/vue-query'
import { apiAxios } from '../helpers/axios.helper'

// const PAYMENT_HISTORY_URL = '/payment/history'
// const PAYMENT_HISTORY_URL = 'https://dummyjson.com/c/4a58-50fd-4f9e-b0f2'
const PAYMENT_HISTORY_URL = 'https://dummyjson.com/c/7f9a-3f73-4653-b4a8'

const fetchPaymentHistory = async () => {
  const response = await apiAxios.get(PAYMENT_HISTORY_URL)

  return response.data
}

export const usePaymentHistory = () => {
  return useQuery({
    queryKey: ['payment_history'],
    queryFn: () => fetchPaymentHistory()
  })
}
