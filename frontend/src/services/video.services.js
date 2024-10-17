import { ADMIN_BASE } from '@constants/api.constant'
import { apiAxios } from '@helpers/axios.helper'
import { useFetch } from '@utils/vue-query.util'
import axios from 'axios'

export const videoService = {
  createVideoSession: async (fileSize, onProgress) => {
    const url = `${ADMIN_BASE}/video/create-upload-session`
    const body = {
      fileSize
    }

    let imposterProgress = 5
    let interval

    const startProgress = () => {
      interval = setInterval(() => {
        if (imposterProgress < 89) {
          const randomIncrement = Math.floor(Math.random() * 10) + 1
          imposterProgress += randomIncrement
          if (imposterProgress >= 100) {
            imposterProgress = 100
          }
          if (onProgress) {
            onProgress(imposterProgress)
          }
        } else {
          onProgress(100)
          clearInterval(interval)
        }
      }, 500)
    }

    try {
      startProgress()

      const response = await apiAxios.post(url, body, {
        onUploadProgress: (progressEvent) => {
          if (progressEvent.total) {
            const realProgress = Math.round((progressEvent.loaded * 100) / progressEvent.total)

            if (realProgress > imposterProgress) {
              clearInterval(interval)
              if (onProgress) {
                onProgress(realProgress)
              }
            }
          }
        }
      })

      return { data: response.data }
    } catch (error) {
      console.error('Signup error:', error)
      throw error
    }
  },

  uploadVideo: async (formdata) => {
    const url = `${ADMIN_BASE}/video/upload-video`
    try {
      const response = await apiAxios.post(url, formdata, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      })
      return response.data
    } catch (error) {
      console.error('Upload video error:', error)
      throw error
    }
  },

  uploadVideoSecondStep: async (uploadLink, videoFile) => {
    const CHUNK_SIZE = 52428800 // 50MB
    let offset = 0

    try {
      while (offset < videoFile.size) {
        const chunk = videoFile.slice(offset, offset + CHUNK_SIZE)

        const response = await axios.patch(uploadLink, chunk, {
          headers: {
            'Tus-Resumable': '1.0.0',
            'Upload-Offset': offset,
            'Content-Type': 'application/offset+octet-stream'
          }
        })

        offset = parseInt(response.headers['upload-offset'], 10)
      }
    } catch (error) {
      console.error('Upload video error:', error)
      throw error
    }
  },

  verifyUpload: async (uploadLink) => {
    try {
      const response = await axios.head(uploadLink, {
        headers: {
          'Tus-Resumable': '1.0.0',
          Accept: 'application/vnd.vimeo.*+json;version=3.4'
        }
      })

      const uploadLength = parseInt(response.headers['upload-length'], 10)
      const uploadOffset = parseInt(response.headers['upload-offset'], 10)

      if (uploadLength === uploadOffset) {
        return true
      } else {
        return false
      }
    } catch (error) {
      console.error('Error verifying upload:', error)
      throw error
    }
  },

  getUploadVideos: (take, page) => {
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
    return useFetch(`${ADMIN_BASE}/video/dashboard`, config)
  },
  createChannel: async () => {
    const url = `/channel`
    try {
      await apiAxios.get(url)
    } catch (error) {
      console.error('Create channel error:', error)
      throw error
    }
  }
}
