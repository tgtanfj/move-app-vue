import { ADMIN_BASE } from '@constants/api.constant'
import { apiAxios } from '@helpers/axios.helper'

export const getSearchResults = async (endpoint, query, limit, page) => {
  try {
    const response = await apiAxios.get(`${ADMIN_BASE}/search/${endpoint}?q=${query}`, {
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
