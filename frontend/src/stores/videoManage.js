import { ADMIN_BASE } from '@constants/api.constant'
import { videoService } from '@services/video.services'
import axios from 'axios'
import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useVideoStore = defineStore('video', () => {
  //State
  const videos = ref([])
  const errorMsg = ref('')
  const isLoading = ref(false)
  const pageCounts = ref([])
  const totalPages = ref()

  //Action
  const getUploadedVideosList = async (take, page) => {
    const token = localStorage.getItem('token')
    const config = {
      headers: {
        Authorization: `Bearer ${token}`
      },
      params: {
        take,
        page
      }
    }
    try {
      isLoading.value = true
      const res = await axios.get(`${ADMIN_BASE}/video/dashboard`, config)
      if (res.status === 200 && res.data.data) {
        videos.value = [...res.data.data]
        pageCounts.value = [...Array.from({ length: res.data.meta.totalPages }, (_, i) => i + 1)]
        totalPages.value = res.data.meta.totalPages
      } else throw new Error(res.error)
    } catch (error) {
      errorMsg.value = error.message
    } finally {
      isLoading.value = false
    }
  }
  const getVideosByLimit = async (limit, page) => {
    isLoading.value = true
    errorMsg.value = null

    try {
      const token = localStorage.getItem('token')
      const config = {
        headers: {
          Authorization: `Bearer ${token}`
        },
        params: {
          take: limit,
          page: page
        }
      }

      const res = await axios.get(`${ADMIN_BASE}/video/dashboard`, config)
      if ((res.statusCode = 200)) {
        videos.value = res.data.data
        pageCounts.value = [
          ...Array.from({ length: res.data.meta.totalPages }, (_, index) => index + 1)
        ]
      } else {
        throw new Error('No data received')
      }
    } catch (err) {
      errorMsg.value = err // Set error message
    } finally {
      isLoading.value = false // Reset loading state
    }
  }

  const deleteVideos = async (videoSelected) => {
    try {
      await axios.delete(`${ADMIN_BASE}/video`, { data: { videoIds: videoSelected } })
      return true
    } catch (error) {
      if (error.response && error.response.data) {
        errorMsg.value = error.response.data.message || "An error occurred"; // Sử dụng thông điệp lỗi nếu có
      } else {
        errorMsg.value = "An unknown error occurred"; // Xử lý lỗi không xác định
      }
    }
  }

  return {
    videos,
    errorMsg,
    isLoading,
    pageCounts,
    getUploadedVideosList,
    getVideosByLimit,
    deleteVideos
  }
})
