import { useFetch } from '@/utils/vue-query.util'
import { ADMIN_BASE } from '@constants/api.constant'

export const userProfileService = {
  getUserProfile: () => {
    const token = localStorage.getItem('token')

    return useFetch(`${ADMIN_BASE}/user/profile`, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    })
  }
}
