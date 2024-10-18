import { ADMIN_BASE } from '@constants/api.constant'
import axios from 'axios'
import { defineStore } from 'pinia'
import { computed, ref, watch } from 'vue'
import { apiAxios } from '../helpers/axios.helper'

const DOWNLOAD_VIDEO_URL = `/video/download`

export const useVideoStore = defineStore('video', () => {
  //State
  const videos = ref([])
  const videoId = ref(null)
  const errorMsg = ref('')
  const isLoading = ref(false)
  const totalPages = ref(0)
  const selectedPage = ref(1)
  const isCopied = ref(false)

  const pageLimit = 5
  const visiblePages = computed(() => {
    if (totalPages.value <= pageLimit) {
      return Array.from({ length: totalPages.value }, (_, i) => i + 1)
    }

    if (selectedPage.value <= 2) {
      return Array.from({ length: pageLimit }, (_, i) => i + 1)
    }

    const start = Math.max(1, selectedPage.value - 2)
    const end = Math.min(start + pageLimit - 1, totalPages.value)

    const adjustedStart = Math.max(1, end - pageLimit + 1)

    return Array.from({ length: end - adjustedStart + 1 }, (_, i) => adjustedStart + i)
  })

  const updateSelectedPage = (value) => {
    selectedPage.value = value
  }

  //Action
  const getUploadedVideosList = async (take, page) => {
    const config = {
      params: {
        take,
        page
      }
    }
    try {
      isLoading.value = true
      const res = await apiAxios.get(`/video/dashboard`, config)
      if (res.status === 200 && res.data.data) {
        videos.value = [...res.data.data]
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
        totalPages.value = res.data.meta.totalPages
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
        errorMsg.value = error.response.data.message || 'An error occurred'
      } else {
        errorMsg.value = 'An unknown error occurred'
      }
    }
  }

  const updateDetailVideo = async (formData) => {
    try {
      const res = await axios.put(`${ADMIN_BASE}/video/edit-video/${videoId.value}`, formData, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      })

      if (res.status === 200) {
        const updatedVideo = res.data.data

        const index = videos.value.findIndex((video) => video.id === videoId.value)

        // if (index !== -1) {
        //   videos.value[index] = updatedVideo
        // }
        if (index !== -1) {
          // Kiểm tra nếu thumbnail từ API là null hoặc undefined thì giữ lại thumbnail cũ
          const currentVideo = videos.value[index]
          if (!updatedVideo.thumbnail) {
            updatedVideo.thumbnail = currentVideo.thumbnail
          }
          
          // Cập nhật lại video trong danh sách
          videos.value[index] = { ...currentVideo, ...updatedVideo }
        }
      }
      return res.data
    } catch (error) {
      console.error('Error updating video:', error)
    }
  }

  const shareVideoSocial = (videoId, option) => {
    const shareFbUrl = 'https://www.facebook.com/sharer/sharer.php?u='
    const shareTwUrl = 'https://twitter.com/intent/tweet?url='
    const showVideoUrl = window.location.origin + '/video/' + videoId

    let shareUrl = ''
    if (option === 'Facebook') {
      shareUrl = shareFbUrl + showVideoUrl
      window.open(shareUrl, '_blank')
    } else if (option === 'Twitter') {
      shareUrl = shareTwUrl + showVideoUrl
      window.open(shareUrl, '_blank')
    } else {
      console.error('Unsupported social media option')
      return
    }
  }

  const getAndCopyUrlVideo = (videoId) => {
    const showVideoUrl = window.location.origin + '/video/' + videoId
    navigator.clipboard.writeText(showVideoUrl)
    isCopied.value = true
    setTimeout(() => {
      isCopied.value = false
    }, 2000)
  }

  const downloadVideo = async (id) => {
    try {
      const response = await apiAxios.get(`${DOWNLOAD_VIDEO_URL}/${id}`)
      return response.data
    } catch (error) {
      console.error('Error downloading videos:', error)
      throw error
    }
  }

  const downloadVideos = async (videoSelected) => {
    try {
      const result = await Promise.all(
        videoSelected.map(async (id) => {
          const response = await apiAxios.get(`${DOWNLOAD_VIDEO_URL}/${id}`)
          return response.data
        })
      )

      return result
    } catch (error) {
      console.error('Error downloading videos:', error)
      throw error
    }
  }

  return {
    //states
    videos,
    videoId,
    errorMsg,
    isLoading,
    isCopied,
    selectedPage,
    visiblePages,
    totalPages,
    updateSelectedPage,

    //actions
    getUploadedVideosList,
    getVideosByLimit,
    deleteVideos,
    updateDetailVideo,
    shareVideoSocial,
    getAndCopyUrlVideo,
    downloadVideo,
    downloadVideos
  }
})
