<script setup>
import Categories from '@components/home/Categories.vue'
import { useSearchStore } from '../stores/search'
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import Channel from '@components/search/Channel.vue'
import Video from '@components/home/Video.vue'
import SeparatorCross from '@components/SeparatorCross.vue'
import { ChevronsLeft, ChevronsRight } from 'lucide-vue-next'
import Loading from '@components/Loading.vue'
import SearchVideo from '@components/search/SearchVideo.vue'
import NoResult from '@components/search/NoResult.vue'

const searchStore = useSearchStore()

const route = useRoute()
const searchQuery = computed(() => route.query.query)
const numberOfVideos = ref(6)
const currentVideoPage = ref(1)
const currentCategoryPage = ref(1)
const currentChannelPage = ref(1)
const isFetchingVideos = ref(false)

const videoSection = ref(null)

onMounted(() => {
  searchQuery && searchStore.getResultsByQuery(searchQuery.value)
  window.addEventListener('scroll', handleScroll)
})

watch(searchQuery, (newValue) => {
  newValue && searchStore.getResultsByQuery(newValue)
})

onBeforeUnmount(() => {
  window.removeEventListener('scroll', handleScroll)
})

const loadMore = async (query, page, numberOfVideos) => {
  await searchStore.loadMoreVideos(query, page, numberOfVideos)
  currentVideoPage.value = page
  if (videoSection.value) {
    videoSection.value.scrollIntoView({
      behavior: 'smooth',
      block: 'end',
      inline: 'nearest'
    })
  }
}

const handleScroll = () => {
  const videoSection = document.querySelector('#videoSection')
  if (!videoSection || isFetchingVideos.value) return
  const scrollPosition = window.innerHeight + window.scrollY
  const threshold = videoSection.offsetTop + videoSection.clientHeight - 10

  if (scrollPosition >= threshold) {
    const nextPage = currentVideoPage.value + 1
    const totalPages = searchStore.searchResults.videos.metadata.totalPages
    if (nextPage > totalPages) return
    isFetchingVideos.value = true
    loadMore(searchQuery.value, nextPage, numberOfVideos.value).finally(() => {
      isFetchingVideos.value = false
    })
  }
}

const handleLoadMoreCategories = () => {
  const nextPage = currentCategoryPage.value + 1
  const totalPages = searchStore.searchResults.categories?.metadata.totalPages
  if (nextPage > totalPages) return
  searchStore.loadMoreCategories(nextPage, searchQuery.value)
  currentCategoryPage.value = nextPage
}
const handleBackCategories = () => {
  const previousPage = currentCategoryPage.value - 1
  if (previousPage < 1) return

  searchStore.loadMoreCategories(previousPage, searchQuery.value)
  currentCategoryPage.value = previousPage
}

const handleLoadMoreChannels = () => {
  const nextPage = currentChannelPage.value + 1
  const totalPages = searchStore.searchResults.channels?.metadata.totalPages

  if (nextPage > totalPages) return

  searchStore.loadMoreChannels(nextPage, searchQuery.value)
  currentChannelPage.value = nextPage
}

const handleBackChannels = () => {
  const previousPage = currentChannelPage.value - 1
  if (previousPage < 1) return

  searchStore.loadMoreChannels(previousPage, searchQuery.value)
  currentChannelPage.value = previousPage
}
</script>
<template>
  <div :style="{ height: 'calc(100vh - 56px)' }">
    <div v-if="searchStore.isLoading" class="h-full w-full flex items-center justify-center">
      <Loading />
    </div>
    <div v-else>
      <div className="w-[90%] flex flex-col flex-grow ml-7" v-if="searchQuery.length > 0">
        <div
          v-if="
            searchStore.searchResults.categories?.data?.length > 0 ||
            searchStore.searchResults.channels?.data?.length > 0 ||
            searchStore.searchResults.videos?.data?.length > 0
          "
          class="mt-5 mr-5 flex flex-col"
          :style="{ height: 'calc(100vh - 60px)' }"
        >
          <SeparatorCross
            :title="`${$t('search.result_for')} ${searchQuery ? searchQuery : searchStore.text ? searchStore.text : ''}`"
            class="mt-3"
          />
          <!-- 1. Search Result: Categories -->
          <div
            class="mt-6 pb-6 border-b-[3px] border-b-[#cccccc]"
            v-if="searchStore.searchResults.categories?.data?.length > 0"
          >
            <div class="flex justify-between">
              <h2 class="text-xl font-bold mb-3">{{ $t('search.category') }}</h2>
              <div class="flex items-center gap-3">
                <p
                  class="cursor-pointer text-primary flex gap-[.5px] items-center"
                  :class="{ hidden: currentCategoryPage === 1 }"
                  @click="handleBackCategories"
                >
                  Back
                </p>
                <p
                  class="cursor-pointer text-primary flex gap-[.5px] items-center"
                  :class="{
                    hidden:
                      currentCategoryPage >=
                      searchStore.searchResults.categories?.metadata?.totalPages
                  }"
                  @click="handleLoadMoreCategories"
                >
                  Next
                </p>
              </div>
            </div>
            <div class="grid gap-3 grid-cols-6 grid-rows-1">
              <div v-for="item in searchStore.searchResults?.categories?.data" :key="item.id">
                <Categories :category="item" :imageHeight="220" />
              </div>
            </div>
          </div>
          <!-- 2.Search Result : Channel -->
          <div
            class="mt-6 pb-6 border-b-[3px] border-b-[#cccccc]"
            v-if="searchStore.searchResults.channels?.data?.length > 0"
          >
            <div class="flex justify-between">
              <h2 class="text-xl font-bold mb-3">{{ $t('search.channels') }}</h2>
              <div class="flex items-center gap-3">
                <p
                  class="cursor-pointer text-primary flex gap-[.5px] items-center"
                  :class="{ hidden: currentChannelPage === 1 }"
                  @click="handleBackChannels"
                >
                  Back
                </p>
                <p
                  class="cursor-pointer text-primary flex gap-[.5px] items-center"
                  @click="handleLoadMoreChannels"
                  :class="{
                    hidden:
                      currentCategoryPage >=
                      searchStore.searchResults.channels?.metadata?.totalPages
                  }"
                >
                  Next
                </p>
              </div>
            </div>
            <div class="grid grid-cols-2 grid-rows-4">
              <Channel
                v-for="channel in searchStore.searchResults.channels?.data"
                :key="channel.name"
                :channel="channel"
              />
            </div>
          </div>
          <!-- 3.Search Result: Videos -->
          <div
            class="mt-6 pb-6 border-b-[3px] border-b-[#cccccc]"
            id="videoSection"
            ref="videoSection"
            @scroll="handleScroll"
            v-if="searchStore.searchResults.videos?.data.length > 0"
          >
            <h2 class="text-xl font-bold mb-3">{{ $t('search.videos') }}</h2>
            <div class="grid grid-cols-3 grid-rows-1 gap-5">
              <SearchVideo
                v-for="video in searchStore.searchResults.videos?.data"
                :video="video"
                :key="video.id"
              />
            </div>
            <div
              class="w-full flex mt-6 mb-2 justify-center"
              v-if="searchStore.isLoadingMoreVideos"
            >
              <Loading />
            </div>
          </div>
        </div>
        <!-- No search results -->
        <NoResult v-else :searchQuery="searchQuery" />
      </div>
    </div>
  </div>
</template>
