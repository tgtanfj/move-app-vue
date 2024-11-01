<script setup>
import { commentServices } from '@services/comment.services'
import { onMounted, onUnmounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import RenderComment from './RenderComment.vue'
import WriteComment from './WriteComment.vue'
import { useCommentToggleStore } from '../../stores/commentToggle.store'
import LoadingTable from '@components/LoadingTable.vue'
import Loading from '@components/Loading.vue'

const props = defineProps({
  isCommentable: {
    type: Boolean,
    required: true
  },
  commentFirst: {
    type: Object,
    required: true
  }
})

const commentToggleStore = useCommentToggleStore()

const commentData = ref([])
const isLoading = ref(false)
const hasMoreComments = ref(true)
const isInitialLoading = ref(true)
const cursor = ref(null)
const commentFromChild = ref(null)
const route = useRoute()

const videoId = route.params.id

onMounted(async () => {
  window.addEventListener('scroll', handleScroll)
  await loadComments()
  isInitialLoading.value = false
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})

const handlePushCommentFromChild = (data) => {
  commentFromChild.value = data
  commentData.value.unshift(data)
}

const updateReplyCount = (id, newReplyCount) => {
  const targetComment = commentData.value.find((c) => c.id === id)
  if (targetComment) {
    targetComment.numberOfReply = targetComment.numberOfReply + newReplyCount
  }
}

const loadComments = async () => {
  if (!hasMoreComments.value || isLoading.value) return
  isLoading.value = true

  try {
    const response = await commentServices.getCommentsByVideoId(cursor.value, videoId)
    const newComments = response.data

    if (newComments.length > 0) {
      newComments.forEach((comment) => {
        const exists = commentData.value.some(
          (existingComment) => existingComment.id === comment.id
        )
        if (!exists) {
          commentData.value.push(comment)
        }
      })
      cursor.value = newComments[newComments.length - 1].id
    } else {
      hasMoreComments.value = false
    }
  } catch (error) {
    console.error('Error loading comments:', error)
  } finally {
    isLoading.value = false
  }
}

const handleScroll = () => {
  const bottomReached = window.innerHeight + window.scrollY >= document.body.offsetHeight - 10
  if (bottomReached && !isLoading.value) {
    loadComments()
  }
}

watch(
  () => props.commentFirst,
  (newComment) => {
    if (newComment) {
      const exists = commentData.value.some((comment) => comment.id === newComment.id)
      if (!exists) {
        commentData.value.unshift(newComment)
      }
    }
  },
  { immediate: true }
)

const handleUpdateComments = (updatedComments) => {
  commentData.value = updatedComments
}
</script>

<template>
  <div v-if="commentToggleStore.isCommentable" class="w-full">
    <div class="w-full">
      <WriteComment
        :videoId="videoId"
        :comments="commentData"
        @update="handlePushCommentFromChild"
      />
    </div>
    <div class="w-full mt-10">
      <div v-if="isInitialLoading" class="w-full flex flex-col items-center justify-center pt-6">
        <Loading />
      </div>
      <RenderComment
        v-else-if="commentData.length !== 0"
        :videoId="videoId"
        :comments="commentData"
        @update-comments="handleUpdateComments"
        @updateReplyCount="updateReplyCount"
      />
      <div v-else class="w-full flex flex-col items-center justify-center pt-6">
        <p class="text-[16px]">No comments to display</p>
        <p class="text-[14px] text-[#666666]">Leave a comment to get started</p>
      </div>
    </div>
  </div>

  <div
    v-else-if="!commentToggleStore.isCommentable && commentToggleStore.isInstructor"
    class="w-full"
  >
    <div class="w-full mt-10">
      <RenderComment
        v-if="commentData.length !== 0"
        :videoId="videoId"
        :comments="commentData"
        @update-comments="handleUpdateComments"
        @updateReplyCount="updateReplyCount"
      />
      <div v-else class="w-full flex flex-col items-center justify-center pt-6">
        <p class="text-[16px]">No comments to display</p>
        <p class="text-[14px] text-[#666666]">Leave a comment to get started</p>
      </div>
    </div>
  </div>

  <div v-else class="flex w-full items-center justify-center">
    <p class="text-black text-base mt-4">Comments feature has been disabled.</p>
  </div>
</template>
