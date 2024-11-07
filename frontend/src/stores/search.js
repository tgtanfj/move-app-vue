import { ADMIN_BASE } from '@constants/api.constant'
import { apiAxios } from '@helpers/axios.helper'
import axios from 'axios'
import { defineStore } from 'pinia'
import { ref, watch } from 'vue'
import { getSearchResults } from '@utils/search.util'

export const useSearchStore = defineStore('search', () => {
  const isLoading = ref(false)
  const text = ref('')
  const debounceTime = ref(null)
  const history = ref([])
  const showResultBox = ref(false)
  //This results variable hold value of search modal in navbar
  const results = ref({})
  const isLoadingMoreVideos = ref(false)
  const isClearingText = ref(false)

  // This searchResults variable hold value in search page (search by query text)
  const searchResults = ref({
    videos: {
      data: [],
      metadata: {}
    },
    channels: {
      data: [],
      metadata: {}
    },
    categories: {
      data: [],
      metadata: {}
    }
  })

  const updateClearingText = (value) => {
    isClearingText.value = value
  }

  const closeResultBox = () => {
    showResultBox.value = false
    results.value = {}
  }

  const fetchResults = async (query) => {
    try {
      const response = await axios.get(`${ADMIN_BASE}/search/suggestion?q=${query}`)
      if (response.status === 200) {
        results.value = response.data.data
      }
    } catch (error) {
      console.log(error.message)
      results.value = {}
    }
  }
  const debounceFetch = (query) => {
    showResultBox.value = true
    clearTimeout(debounceTime.value)
    debounceTime.value = setTimeout(() => {
      fetchResults(query)
    }, 300)
  }

  const getUserHistory = async (postHistory) => {
    try {
      const response = await apiAxios.get(`${ADMIN_BASE}/search/history`)
      if (response.status === 200 && response.data.data.histories.length > 0) {
        history.value = [...response.data.data.histories]
        if (!postHistory) showResultBox.value = true
      } else {
        showResultBox.value = false
        return
      }
    } catch (error) {
      console.log(error.message)
    }
  }
  const postUserHistory = async (query) => {
    try {
      const res = await apiAxios.post(`/search/history`, {
        content: query
      })
      if (res.status === 201) {
        await getUserHistory(true)
      } else throw new Error(res.error)
    } catch (error) {
      console.log(error)
    }
  }
  const deleteUserHistory = async (content) => {
    try {
      const response = await apiAxios.delete(`/search/history?content=${content}`)
      if (response.status === 200) {
        history.value = history.value.filter((item) => item.content !== content)
        if (history.value.length === 0) showResultBox.value = false
      } else throw new Error(response.data)
    } catch (error) {
      console.log(error)
    }
  }
  const getResultsByQuery = async (query) => {
    isLoading.value = true
    const categoriesPromise = getSearchResults('categories', query, 6, 1)
    const channelsPromise = getSearchResults('channels', query, 8, 1)
    const videosPromise = getSearchResults('videos', query, 6, 1)

    const results = await Promise.allSettled([categoriesPromise, channelsPromise, videosPromise])

    results.forEach((result, index) => {
      if (result.status === 'fulfilled') {
        const { data, meta } = result.value
        switch (index) {
          case 0:
            searchResults.value = {
              ...searchResults.value,
              categories: { ...searchResults.value.categories, data, metadata: meta }
            }
            break
          case 1:
            searchResults.value = {
              ...searchResults.value,
              channels: { ...searchResults.value.channels, data, metadata: meta }
            }
            break
          case 2:
            searchResults.value = {
              ...searchResults.value,
              videos: { ...searchResults.value.channels, data, metadata: meta }
            }
            break
        }
      } else {
        console.error(`Error fetching results: ${result.reason.message}`)
      }
    })

    isLoading.value = false
  }

  const loadMoreVideos = async (query, page, numberOfVideos) => {
    isLoadingMoreVideos.value = true
    const totalPages = searchResults.value.videos.metadata.totalPages
    if (page > totalPages) {
      isLoadingMoreVideos.value = false
      return
    }
    try {
      const res = await apiAxios.get(`/search/videos?q=${query}`, {
        params: {
          limit: numberOfVideos ? numberOfVideos : 6,
          page
        }
      })
      if (res.status === 200) {
        const { data, meta } = res.data
        if (data.length > 0) {
          searchResults.value = {
            ...searchResults.value,
            videos: {
              data: [...searchResults.value.videos.data, ...data],
              metadata: meta
            }
          }
        } else console.log('No new videos to load')
      }
    } catch (error) {
      console.log(error)
    } finally {
      isLoadingMoreVideos.value = false
    }
  }

  const loadMoreCategories = async (page, query) => {
    try {
      const res = await apiAxios(`/search/categories?q=${query}`, {
        params: {
          limit: 6,
          page
        }
      })
      if (res.status === 200 && res.data.data.length > 0) {
        searchResults.value.categories.data = [...res.data.data]
      }
    } catch (error) {
      console.log(error.message)
    }
  }
  const loadMoreChannels = async (page, query) => {
    try {
      const res = await apiAxios(`/search/channels?q=${query}`, {
        params: {
          limit: 8,
          page
        }
      })
      if (res.status === 200 && res.data.data.length > 0) {
        searchResults.value.channels.data = [...res.data.data]
      }
    } catch (error) {
      console.log(error.message)
    }
  }

  return {
    text,
    isLoading,
    results,
    debounceTime,
    showResultBox,
    searchResults,
    isLoadingMoreVideos,
    history,
    isClearingText,
    updateClearingText,
    closeResultBox,
    debounceFetch,
    getResultsByQuery,
    loadMoreVideos,
    getUserHistory,
    postUserHistory,
    deleteUserHistory,
    loadMoreCategories,
    loadMoreChannels
  }
})
