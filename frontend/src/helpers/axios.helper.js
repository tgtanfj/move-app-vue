import axios from 'axios'
import { ADMIN_BASE } from '../constants/api.constant'
import { useAuthStore } from '../stores/auth'

// Create an axios instance
export const apiAxios = axios.create({
  baseURL: ADMIN_BASE // Set the base URL for your API
})

// Add a request interceptor
apiAxios.interceptors.request.use(
  (config) => {
    const authStore = useAuthStore()
    const token = authStore.accessToken || localStorage.getItem('token')
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

apiAxios.interceptors.response.use(
  (response) => response,
  async (error) => {
    const { response } = error
    const authStore = useAuthStore()
    if (response && response.data.message === 'jwt') {
      try {
        const refreshToken = localStorage.getItem('refreshToken')
        const res = await axios.get(`${ADMIN_BASE}/auth/refresh`, {
          headers: {
            Authorization: `Bearer ${refreshToken}`
          }
        })

        if (res.status === 200) {
          const { accessToken } = res.data.data
          localStorage.setItem('token', accessToken)
          apiAxios.defaults.headers.common['Authorization'] = `Bearer ${accessToken}`
          authStore.user.accessToken = accessToken
        }
      } catch (refreshError) {
        console.error('Token refresh failed:', refreshError)
        localStorage.removeItem('accessToken')
        localStorage.removeItem('refreshToken')
        localStorage.removeItem('userAvatar')
        localStorage.removeItem('userEmail')
        localStorage.removeItem('userInfo')
        window.location.href = '/'
        return Promise.reject(refreshError)
      }
    }
    return Promise.reject(error)
  }
)
