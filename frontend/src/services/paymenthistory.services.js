import { useQuery } from '@tanstack/vue-query'
import { apiAxios } from '../helpers/axios.helper'

const PAYMENT_HISTORY_URL = '/payment/history'

const fetchPaymentHistory = async (startDate, endDate, take, page) => {
  const response = await apiAxios.get(
    `${PAYMENT_HISTORY_URL}?startDate=${startDate}&endDate=${endDate}&take=${take}&page=${page}`
  )

  return response.data
}

export const usePaymentHistory = (startDate, endDate, take, page) => {
  return useQuery({
    queryKey: ['payment_history'],
    queryFn: () => fetchPaymentHistory(startDate.value, endDate.value, take.value, page.value)
  })
}
