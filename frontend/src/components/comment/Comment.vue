<script setup>
import { commentServices } from '@services/comment.services'
import { onMounted, onUnmounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import RenderComment from './RenderComment.vue'
import WriteComment from './WriteComment.vue'

const props = defineProps({
  isCommentable: {
    type: Boolean,
    required: true
  }
})

const commentData = ref([])
const isLoading = ref(false)
const hasMoreComments = ref(true)
const cursor = ref(null)
const commentFromChild = ref(null)
const route = useRoute()

const videoId = route.params.id

onMounted(async () => {
  window.addEventListener('scroll', handleScroll)
  loadComments()
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
      commentData.value.push(...newComments)
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

const handleUpdateComments = (updatedComments) => {
  commentData.value = updatedComments
}
</script>

<template>
  <div class="w-full" v-if="isCommentable">
    <div class="w-full">
      <WriteComment
        :videoId="videoId"
        :comments="commentData"
        @update="handlePushCommentFromChild"
      />
    </div>
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
