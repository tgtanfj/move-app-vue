commentVideo:
<script setup>
import { onMounted, onUnmounted, ref } from 'vue'
import RenderComment from './RenderComment.vue'
import WriteComment from './WriteComment.vue'
import { commentServices } from '@services/comment.services'
import { useAuthStore } from '../../stores/auth'

const commentData = ref([])
const isLoading = ref(false)
const hasMoreComments = ref(true)
const cursor = ref(null)
const commentFromChild = ref(null)

const userStore = useAuthStore()

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

const loadComments = async () => {
  if (!hasMoreComments.value || isLoading.value) return
  isLoading.value = true

  try {
    const response = await commentServices.getCommentsByVideoId(cursor.value)
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
  <div class="w-full">
    <div class="w-full">
      <WriteComment
        :comments="commentData"
        :me="userStore?.user"
        @update="handlePushCommentFromChild"
      />
    </div>
    <div class="w-full mt-10">
      <RenderComment :comments="commentData" @update-comments="handleUpdateComments" />
    </div>
  </div>
</template>
