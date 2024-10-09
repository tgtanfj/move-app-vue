import { ADMIN_BASE } from '@constants/api.constant'
import axios from 'axios'
import { defineStore } from 'pinia'
import { ref } from 'vue'
import { apiAxios } from '../helpers/axios.helper'

const DOWNLOAD_VIDEO_URL = `/video/download`

export const useVideoStore = defineStore('video', () => {
  //State
  const videos = ref([])
  const videoId = ref(null)
  const errorMsg = ref('')
  const isLoading = ref(false)
  const pageCounts = ref([])
  const totalPages = ref()
  const isCopied = ref(false);

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
        errorMsg.value = error.response.data.message || "An error occurred"
      } else {
        errorMsg.value = "An unknown error occurred"
      }
    }
  }

  const updateDetailVideo = async (formData) => {
    try {
      const res = await axios.put(`${ADMIN_BASE}/video/edit-video/${videoId.value}`, formData, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      });
      
      if (res.status === 200) {
        const index = videos.value.findIndex(video => video.id === videoId.value);
        if (index !== -1) {
          videos.value[index] = { ...videos.value[index], ...formData };
        }
      }
      return res.data;
    } catch (error) {
      console.error('Error updating video:', error);
    }

    // for (let [key, value] of formData.entries()) {
    //   console.log(key, value); // In ra key-value của formData
    // }
  }

  const shareVideoSocial = async (videoId, option) => {
    try {
      const response = await axios.get(`${ADMIN_BASE}/video/social-sharing/${videoId}?option=${option}`)

      if (response.status === 200) {
        const shareUrl = response.data.data
        window.open(shareUrl, '_blank')
      } else {
        console.error('Failed to share video:', response.statusText)
      }
    } catch (error) {
      console.error('Error sharing video:', error)
    }
  }

  const getAndCopyUrlVideo = async (videoId) => {
    try {
      const response = await axios.get(`${ADMIN_BASE}/video/${videoId}`)

      if (response.status === 200) {
        const videoUrl = response.data.data

        await navigator.clipboard.writeText(videoUrl)

        isCopied.value = true;

        setTimeout(() => {
          isCopied.value = false
        }, 2000);
      } else {
        console.error('Failed to get video URL:', response.statusText)
      }
    } catch (error) {
      console.error('Error getting video URL:', error)
    }
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
    pageCounts,
    isCopied,

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