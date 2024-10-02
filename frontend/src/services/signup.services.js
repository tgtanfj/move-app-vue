import { ADMIN_BASE } from '@constants/api.constant'
import axios from 'axios'

export const signupService = {
  signupByEmailPassword: async (email) => {
    const url = `${ADMIN_BASE}/auth/send-otp`
    const body = {
      email
    }

    try {
      const response = await axios.post(url, body)
      return response.data
    } catch (error) {
      console.error('Signup error:', error)
      throw error
    }
  }
}
