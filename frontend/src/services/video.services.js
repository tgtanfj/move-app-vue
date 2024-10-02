import { useFetch } from '@utils/vue-query.util'
import { ADMIN_BASE } from '@constants/api.constant'

export const videoService = {
  getUploadVideos: (token, take, page) => {
    const config = {
      headers: {
        Authorization: `Bearer ${token}`
      },
      params: {
        take,
        page
      }
    }
    return useFetch(`${ADMIN_BASE}/video/dashboard`, config)
  }
}
