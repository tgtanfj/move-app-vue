<script setup>
import { ADMIN_BASE } from '@constants/api.constant'
import Player from '@vimeo/player'
import axios from 'axios'
import { RotateCw } from 'lucide-vue-next'
import { onBeforeUnmount, onMounted, watch } from 'vue'
import { ref } from 'vue'
import { useRoute } from 'vue-router'

const props = defineProps({
  videoUrl: {
    type: String,
    required: true
  },
  videoId: {
    type: String,
    required: true
  }
})

const isOverlayVisible = ref(false)

const vimeoPlayer = ref(null)
let hasViewed = false
let startTime = null
let totalDuration = 0
let interval
let viewTime = 0

const handleReplay = () => {
  isOverlayVisible.value = false
  const player = new Player(vimeoPlayer.value)
  player.play()
}

const increaseViewCount = async () => {
  const viewCounter = {
    videoId: props.videoId,
    date: new Date().toISOString().split('T')[0]
  }
  try {
    await axios.post(`${ADMIN_BASE}/view`, viewCounter)
  } catch (error) {
    console.log(error)
  }
}

const sendViewTime = async () => {
  if (viewTime >= 0.7 * totalDuration) {
    const viewCounter = {
      videoId: props.videoId,
      date: new Date().toISOString().split('T')[0],
      viewTime
    }
    try {
      await axios.post(`${ADMIN_BASE}/view`, viewCounter)
    } catch (error) {
      console.log(error)
    }
  }
}

onMounted(() => {
  const player = new Player(vimeoPlayer.value)
  const route = useRoute()

  player
    .getDuration()
    .then((duration) => {
      totalDuration = duration
    })
    .catch((error) => {
      console.error('Error getting duration:', error)
    })

  player.on('play', () => {
    startTime = Date.now()
    interval = setInterval(() => {
      player.getCurrentTime().then((seconds) => {
        const percentage = (seconds / totalDuration) * 100

        if (percentage >= 70 && !hasViewed) {
          increaseViewCount()
          hasViewed = true
        }
      })
    }, 1000)
  })

  player.on('pause', () => {
    updateViewTime()
    clearInterval(interval)
  })

  player.on('ended', () => {
    updateViewTime()
    isOverlayVisible.value = true
    clearInterval(interval)

    sendViewTime()
  })

  const updateViewTime = () => {
    if (startTime) {
      const timeSpent = Math.floor((Date.now() - startTime) / 1000)
      viewTime += timeSpent
      startTime = null
    }
  }

  watch(
    () => route.path,
    () => {
      updateViewTime()
      sendViewTime()
    }
  )

  onBeforeUnmount(() => {
    updateViewTime()
    if (hasViewed) sendViewTime()
    clearInterval(interval)
  })
})
</script>
<template>
  <div class="relative w-full pb-[56.25%] h-0 overflow-hidden">
    <iframe
      ref="vimeoPlayer"
      :src="props.videoUrl"
      class="absolute top-0 left-0 w-full h-full"
      frameborder="0"
      allow="autoplay; fullscreen"
    >
    </iframe>
    <div
      v-if="isOverlayVisible"
      class="absolute top-0 right-0 left-0 bottom-0 flex justify-center items-center bg-[#151718] z-10"
    >
      <p class="text-2xl text-white">The video has ended.</p>
      <button
        @click="handleReplay"
        class="absolute left-3 bottom-3 bg-[#020202] rounded-sm hover:bg-[#00ADEF] duration-150 px-4 py-1"
      >
        <RotateCw color="#FFF" size="26" strokeWidth="2.5" />
      </button>
    </div>
  </div>
</template>
