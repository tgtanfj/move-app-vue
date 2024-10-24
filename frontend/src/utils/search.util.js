import { ADMIN_BASE } from '@constants/api.constant'
import axios from 'axios'

export const getSearchResults = async (endpoint, query, limit, page) => {
  try {
    const response = await axios.get(`${ADMIN_BASE}/search/${endpoint}?q=${query}`, {
      params: {
        page,
        limit
      }
    })
    if (response.status === 200) {
      return response.data
    } else throw new Error(response.error)
  } catch (error) {
    return error
  }
}
