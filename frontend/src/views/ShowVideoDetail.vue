<script setup lang="ts">
import VideoLeft from '@components/showVideoDetail/VideoLeft.vue';
import VideoRight from '@components/showVideoDetail/VideoRight.vue';
import { onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const videoId = route.params.id
const videoDetail = ref(null)

const getVideoDetailById = () => {
  // console.log(videoId)
}

onMounted(() => {
  getVideoDetailById()
})

</script>

<template>
  <div class="flex min-h-screen">
    <VideoLeft :videoDetail="videoDetail" />
    <VideoRight :videoDetail="videoDetail" />
  </div>
</template>

