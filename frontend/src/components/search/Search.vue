<script setup>
import SearchIcon from '@assets/icons/SearchIcon.vue'
import { Button } from '@common/ui/button'
import { Clock, Search, X } from 'lucide-vue-next'
import { onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../../stores/auth'
import { useSearchStore } from '../../stores/search'
import BlueBadgeIcon from '@assets/icons/BlueBadgeIcon.vue'

const searchStore = useSearchStore()
const router = useRouter()
const authStore = useAuthStore()
const resultModal = ref(null)
const deleteButtonRef = ref(null)

onMounted(() => {
  window.addEventListener('click', handleCloseResultModal)
})
onBeforeUnmount(() => {
  window.removeEventListener('click', handleCloseResultModal)
})

watch(
  () => searchStore.text,
  (newValue) => {
    if (newValue === '') {
      if (authStore.accessToken && newValue === '' && searchStore.isClearingText) {
        searchStore.getUserHistory() // Call API only if not closing by click
      }
      if (!authStore.accessToken) {
        searchStore.closeResultBox()
      }
    } else {
      searchStore.debounceFetch(newValue)
    }
  }
)

const handleCloseResultModal = (event) => {
  const modal = resultModal.value
  const deleteBtn = deleteButtonRef.value

  // Check if the click is outside the modal and not on the delete button
  const isClickOutsideModal = modal && !modal.contains(event.target)
  const isClickOnDeleteButton = deleteBtn && deleteBtn.contains && deleteBtn.contains(event.target)

  if (isClickOutsideModal && !isClickOnDeleteButton) {
    searchStore.updateClearingText(true)
    searchStore.closeResultBox()
    searchStore.updateClearingText(false)
  }
}

const redirectToSearch = (query) => {
  searchStore.text = query
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
const redirectToCategory = (endpoint, query, id) => {
  searchStore.text = query
  router.push(`/${endpoint}/${query}/${id}`)
  searchStore.closeResultBox()
}
const redirectToVideoAndChannel = (endpoint, query, id) => {
  searchStore.text = query
  router.push(`/${endpoint}/${id}`)
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
  <div class="flex flex-1 justify-end relative">
    <form class="flex items-center" @submit.prevent="onSubmit" ref="resultModal">
      <input
        type="text"
        class="h-full w-[280px] rounded-[0.5rem_0_0_0.5rem] px-3 font-semibold text-black outline-none"
        placeholder="Search"
        v-model.trim="searchStore.text"
        @focus="handleFocus"
        :maxlength="255"
      />
      <Button type="submit" class="w-[44px] rounded-[0_0.5rem_0.5rem_0]">
        <SearchIcon />
      </Button>
    </form>

    <div
      class="absolute bg-white top-full w-[324px] rounded-md shadow-md p-2 pl-0 pt-0 z-20 transition-opacity duration-500 ease-in-out opacity-0 mt-1"
      :class="searchStore.showResultBox ? 'flex opacity-100' : 'hidden'"
    >
      >
      <div
        class="flex flex-col mb-3 w-full"
        v-if="authStore.accessToken && searchStore.history.length > 0 && searchStore.text === ''"
      >
        <div v-for="item in searchStore.history.slice(0, 5)" :key="item.id" class="">
          <div class="flex justify-between hover:bg-gray-100 pr-2 mt-3 py-2 rounded-lg">
            <div class="flex gap-4 items-center pl-2 pr-1">
              <Clock color="#CCCCCC" />
              <p
                @click="redirectToSearch(item?.content)"
                class="text-base text-black cursor-pointer min-w-[150px]"
              >
                {{
                  item?.content && item?.content.length > 20
                    ? item.content.slice(0, 20) + '...'
                    : item.content
                }}
              </p>
            </div>
            <div
              ref="deleteButtonRef"
              class="cursor-pointer"
              @click.stop="handleDeleteHistory(item.content)"
            >
              <X color="#000000" :size="16" />
            </div>
          </div>
        </div>
      </div>
      <div v-if="searchStore.text !== ''" class="w-full">
        <!-- 1 Category -->
        <div
          v-if="
            Array.isArray(searchStore.results?.topCategories) &&
            searchStore.results?.topCategories.length > 0
          "
          class="mt-4 w-full"
        >
          <div class="flex items-center justify-between mb-1">
            <div
              v-for="item in searchStore.results.topCategories"
              :key="item.id"
              class="flex justify-between items-center gap-5 cursor-pointer flex-1"
            >
              <div
                class="flex items-center"
                @click="redirectToCategory('categories', item.title.toLowerCase(), item.id)"
              >
                <img :src="item.image" alt="item.name" class="w-[60px] h-[90px]" />
                <p class="text-base font-medium text-black capitalize ml-4 mr-1">
                  {{
                    item.title && item.title.length > 10
                      ? item.title.slice(0, 10) + '...'
                      : item.title
                  }}
                </p>
              </div>
              <p class="italic text-gray-500 text-base ml-5">Categories</p>
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
            <div
              class="flex items-center"
              @click="redirectToVideoAndChannel('channel', item.name, item.id)"
            >
              <img :src="item.image" alt="item.name" class="w-[60px] h-[60px] rounded-full" />
              <p class="text-base font-medium text-black capitalize ml-4 mr-1">
                {{
                  item.name && item.name.length > 10 ? item.name.slice(0, 10) + '...' : item.name
                }}
              </p>
              <BlueBadgeIcon v-if="item.isBlueBadge" />
            </div>
            <p class="italic text-gray-500 text-base">Instructor</p>
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
            <div
              class="flex items-center"
              @click="redirectToVideoAndChannel('video', item.title, item.id)"
            >
              <img
                :src="item.thumbnails[0]?.image"
                :alt="item.title"
                class="w-[60px] h-[50px] cursor-pointer"
              />
              <p class="text-base font-medium text-black capitalize ml-4 cursor-pointer">
                {{ item?.title.length > 20 ? item.title.slice(0, 20) + '...' : item.title }}
              </p>
            </div>
            <p class="italic text-gray-500 text-base">Video</p>
          </div>
        </div>
        <!-- All search with ... -->
        <div
          @click="redirectToSearch(searchStore.text)"
          class="flex items-center justify-start gap-12 mt-3 cursor-pointer ml-2 mb-2"
        >
          <Search size="20" color="#13D0B4" />
          <p class="text-base text-black">
            All results for
            <strong class="text-base">{{
              searchStore.text && searchStore.text.length > 10
                ? searchStore.text.slice(0, 10) + '...'
                : searchStore.text
            }}</strong>
          </p>
        </div>
      </div>
    </div>
  </div>
</template>
