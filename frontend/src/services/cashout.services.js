import { apiAxios } from '@helpers/axios.helper'

export const cashoutService = {
  getChannelReps: async () => {
    try {
      const response = await apiAxios.get('/channel/get-reps')
      return response.data
    } catch (error) {
      console.error('Get reps error:', error)
      throw error
    }
  },
  withdraw: async (email, numberOfREPs) => {
    try {
      const body = {
        email,
        numberOfREPs
      }
      const response = await apiAxios.post('/payment/withdraw', body)
      return response.data
    } catch (error) {
      console.error('Withdraw reps error:', error)
      throw error
    }
  },
  setPaypayEmail: async (email) => {
    try {
      const body = {
        emailPayPal: email
      }
      const response = await apiAxios.post('/channel/set-up-paypal', body)
      return response.data
    } catch (error) {
      console.error('Set email paypal error:', error)
      throw error
    }
  }
}
