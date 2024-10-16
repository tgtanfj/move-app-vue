<script setup>
import SearchIcon from '@assets/icons/SearchIcon.vue'
import { Button } from '@common/ui/button'
import { Clock, Search, X } from 'lucide-vue-next'
import { handleError, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { RouterLink, useRouter } from 'vue-router'
import { useAuthStore } from '../../stores/auth'
import { useSearchStore } from '../../stores/search'
import { apiAxios } from '@helpers/axios.helper'
import BlueBadgeIcon from '@assets/icons/BlueBadgeIcon.vue'
import PinkBadgeIcon from '@assets/icons/PinkBadgeIcon.vue'

const searchStore = useSearchStore()
const router = useRouter()
const authStore = useAuthStore()
const resultModal = ref(null)

onMounted(() => {
  window.addEventListener('click', handleCloseResultModal)
})
onBeforeUnmount(() => {
  window.addEventListener('click', handleCloseResultModal)
})

watch(
  () => searchStore.text,
  (newValue) => {
    if (authStore.accessToken && newValue === '') searchStore.getUserHistory()
    if (!authStore.accessToken && newValue === '') searchStore.closeResultBox()
    else searchStore.debounceFetch(newValue)
  }
)

const handleCloseResultModal = (event) => {
  const modal = resultModal.value
  if (modal && !modal.contains(event.target)) {
    searchStore.closeResultBox()
  }
}

const redirectToSearch = (query) => {
  router.push({
    path: '/search',
    query: {
      query
    }
  })
  searchStore.closeResultBox()
  if (searchStore.history.some((item) => item.content === query) || !authStore.accessToken) return
  else {
    searchStore.postUserHistory(query)
  }
}
const redirectTo = (endpoint, query, id) => {
  if (id) {
    router.push(`/${endpoint}/${query}/${id}`)
  } else router.push(`/${endpoint}/${query}`)
  searchStore.closeResultBox()
}
const handleFocus = () => {
  if (authStore.accessToken && searchStore.text === '') searchStore.getUserHistory()
  if (searchStore.text) searchStore.debounceFetch(searchStore.text)
}

const handleDeleteHistory = (content) => {
  searchStore.deleteUserHistory(content)
}

const onSubmit = () => {
  if (searchStore.text === '') return
  redirectToSearch(searchStore.text)
}
</script>

<template>
  <div class="flex flex-1 justify-end relative" ref="resultModal">
    <form class="flex items-center" @submit.prevent="onSubmit">
      <input
        type="text"
        class="h-full max-w-[400px] rounded-[0.5rem_0_0_0.5rem] px-3 font-semibold text-black outline-none"
        placeholder="Search"
        v-model.trim="searchStore.text"
        @focus="handleFocus"
      />
      <Button type="submit" class="w-[44px] rounded-[0_0.5rem_0.5rem_0]">
        <SearchIcon />
      </Button>
    </form>

    <div
      class="absolute bg-white top-full min-w-[340px] rounded-md shadow-md p-4 pt-0 z-20 transition-opacity duration-500 ease-in-out opacity-0 mt-2"
      :class="searchStore.showResultBox ? 'flex opacity-100' : 'hidden'"
    >
      >
      <div
        class="flex flex-col mb-3 w-full"
        v-if="authStore.accessToken && searchStore.history.length > 0 && searchStore.text === ''"
      >
        <div v-for="item in searchStore.history" :key="item.id" class="">
          <div class="flex justify-between hover:bg-gray-100 pr-2 mt-3 py-2 rounded-lg">
            <div class="flex gap-4 items-center">
              <Clock color="#CCCCCC" />
              <p
                @click="redirectToSearch(item?.content)"
                class="text-lg text-black cursor-pointer min-w-[200px]"
              >
                {{
                  item?.content && item?.content.length > 20
                    ? item.content.slice(0, 20) + '...'
                    : item.content
                }}
              </p>
            </div>
            <div class="cursor-pointer" @click="handleDeleteHistory(item.content)">
              <X color="#000000" :size="16" />
            </div>
          </div>
        </div>
      </div>
      <div v-if="searchStore.text !== ''">
        <!-- 1 Category -->
        <div v-if="typeof searchStore.results.topCategory === 'object'" class="mt-4">
          <div class="border-b-[3px] pb-4">
            <div class="flex items-center justify-between mb-1">
              <div
                class="flex items-center gap-3 cursor-pointer"
                @click="
                  redirectTo(
                    'categories',
                    searchStore.results.topCategory?.title.toLowerCase(),
                    searchStore.results.topCategory.id
                  )
                "
              >
                <img
                  :src="searchStore.results.topCategory?.image"
                  alt=""
                  class="w-[60px] h-[90px]"
                />
                <p class="text-xl font-medium text-black capitalize">
                  {{ searchStore.results.topCategory?.title }}
                </p>
              </div>
              <p class="italic text-gray-500 text-lg ml-5">Categories</p>
            </div>
          </div>
        </div>
        <!-- 2 Instructors -->
        <div
          class="flex flex-col gap-3 mt-3"
          v-if="
            Array.isArray(searchStore.results?.topInstructors) &&
            searchStore.results?.topInstructors.length > 0
          "
        >
          <div
            v-for="item in searchStore.results.topInstructors"
            :key="item.id"
            class="flex justify-between items-center gap-5 cursor-pointer"
          >
            <div class="flex items-center" @click="redirectTo('channel', item.id)">
              <img :src="item.image" alt="item.name" class="w-[60px] h-[60px] rounded-full" />
              <p class="text-xl font-medium text-black capitalize ml-4 mr-1">
                {{ item.name }}
              </p>
              <BlueBadgeIcon v-if="item.isBlueBadge" />
              <PinkBadgeIcon v-if="item.isPinkBadge" />
            </div>
            <p class="italic text-gray-500 text-lg">Instructor</p>
          </div>
        </div>
        <!-- 2 Videos -->
        <div
          class="flex flex-col mt-3 gap-3"
          v-if="
            Array.isArray(searchStore.results?.topVideos) &&
            searchStore.results?.topVideos.length > 0
          "
        >
          <div
            v-for="item in searchStore.results.topVideos"
            :key="item.id"
            class="flex items-center justify-between gap-5"
          >
            <div class="flex items-center" @click="redirectTo('video', item.id)">
              <img :src="item.thumbnail_url" alt="" class="w-[60px] h-[50px]" />
              <p class="text-xl font-medium text-black capitalize ml-4">
                {{ item.title }}
              </p>
            </div>
            <p class="italic text-gray-500 text-lg">Video</p>
          </div>
        </div>
        <!-- All search with ... -->
        <div
          @click="redirectToSearch(searchStore.text)"
          class="flex items-center justify-start gap-12 mt-3 cursor-pointer"
        >
          <Search size="32" color="#13D0B4" />
          <p class="text-xl text-black">
            All results for
            <strong class="text-xl">{{
              searchStore.text && searchStore.text.length > 50
                ? searchStore.text.slice(0, 50) + '...'
                : searchStore.text
            }}</strong>
          </p>
        </div>
      </div>
    </div>
  </div>
</template>
