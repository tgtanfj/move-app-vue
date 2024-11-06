import { apiAxios } from '@helpers/axios.helper'

export const commentServices = {
  getCommentsByVideoId: async (cursor, videoId) => {
    try {
      const cursorParams = cursor ? cursor : null

      const response = await apiAxios.get(`/comment/${videoId}/comments`, {
        params: {
          limit: 30,
          cursor: cursorParams
        }
      })
      return response.data
    } catch (error) {
      console.error('Get comment error:', error)
      throw error
    }
  },
  postComment: async (content, videoId) => {
    try {
      const body = {
        content: `${content}`,
        videoId: +videoId
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
      const response = await apiAxios.delete(`/comment-reaction/${commentId}`)
      return response.data
    } catch (error) {
      console.error('Update reaction comment error:', error)
      throw error
    }
  },
  getRepliesByComment: async (commentId, cursor) => {
    const limit = 10
    try {
      const cursorParams = cursor ? cursor : null

      const response = await apiAxios.get(`/comment/${commentId}/reply`, {
        params: {
          limit,
          cursor: cursorParams
        }
      })
      return response.data
    } catch (error) {
      console.error('Get comment error:', error)
      throw error
    }
  },
  postReply: async (content, commentId) => {
    try {
      const body = {
        content: `${content}`,
        commentId: +commentId
      }
      const response = await apiAxios.post(`/comment`, body)
      return response.data
    } catch (error) {
      console.error('Post reply error:', error)
      throw error
    }
  },
  getChannelComments: async (filter, sort, page) => {
    const pageSize = 30
    try {
      const response = await apiAxios.get(`/channel/get-all-comments`, {
        params: {
          filter,
          sort,
          page,
          pageSize
        }
      })
      return response.data
    } catch (error) {
      console.error('Get channel comments error:', error)
      throw error
    }
  },
  deleteCommentById: async (commentId) => {
    try {
      const response = await apiAxios.delete(`/comment/${commentId}`)
      return response.data
    } catch (error) {
      console.error('Delete comments error:', error)
      throw error
    }
  }
}
