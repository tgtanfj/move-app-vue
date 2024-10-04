import axios from 'axios'
import { ADMIN_BASE } from '../constants/api.constant'

// Create an axios instance
export const apiAxios = axios.create({
  baseURL: ADMIN_BASE // Set the base URL for your API
})

// Add a request interceptor
apiAxios.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  (error) => {
    // Handle any request error here
    return Promise.reject(error)
  }
)
