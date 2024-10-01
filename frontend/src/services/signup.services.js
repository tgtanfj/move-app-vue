import { ADMIN_BASE } from '@constants/api.constant'
import axios from 'axios'

export const signupService = {
  signupByEmailPassword: async (email, password, referralCode) => {
    const url = `${ADMIN_BASE}/auth/signup/email`
    const body = {
      email,
      password,
      referralCode
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
