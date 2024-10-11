import { ADMIN_BASE } from '@constants/api.constant'
import { apiAxios } from '@helpers/axios.helper'

export const commentServices = {
  getCommentsByVideoId: async (cursor) => {
    try {
      // let videoIdAPI = videoId ? videoId : 45
      let videoIdAPI = 45

      const cursorParmas = cursor ? cursor : null

      const response = await apiAxios.get(`/comment/${videoIdAPI}/comments`, {
        params: {
          limit: 30,
          cursor: cursorParmas
        }
      })
      return response.data
    } catch (error) {
      console.error('Get comment error:', error)
      throw error
    }
  },
  postComment: async (content) => {
    try {
      const body = {
        content: `${content}`,
        videoId: 45
      }
      const response = await apiAxios.post(`/comment`, body)
      return response.data
    } catch (error) {
      console.error('Post comment error:', error)
      throw error
    }
  },
  createCommentReaction: async (commentId, isLike) => {
    try {
      const body = {
        isLike: isLike,
        commentId: commentId
      }
      const response = await apiAxios.post(`/comment-reaction`, body)
      return response.data
    } catch (error) {
      console.error('Create reaction error:', error)
      throw error
    }
  },
  updateCommentReaction: async (commentId, isLike) => {
    try {
      const body = {
        isLike: isLike,
        commentId: commentId
      }
      const response = await apiAxios.patch(`/comment-reaction`, body)
      return response.data
    } catch (error) {
      console.error('Update reaction comment error:', error)
      throw error
    }
  },
  deleteCommentReaction: async (commentId) => {
    try {
      console.log('typdfa', commentId, typeof commentId)
      const response = await apiAxios.delete(`/comment-reaction/${commentId}`)
      return response.data
    } catch (error) {
      console.error('Update reaction comment error:', error)
      throw error
    }
  }
}
