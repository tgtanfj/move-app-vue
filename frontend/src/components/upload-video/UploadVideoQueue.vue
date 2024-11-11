<script setup>
import Loading from '@components/Loading.vue'
import { useVideoQueueStore } from '../../stores/videoQueue.store'
import { CircleCheck } from 'lucide-vue-next'

const videoQueueStore = useVideoQueueStore()
</script>

<template>
  <div
    v-if="videoQueueStore.isVideoQueueShow"
    class="fixed bottom-0 right-0 m-4 w-[440px] bg-white shadow-lg rounded-lg overflow-hidden"
  >
    <div class="bg-primary text-white px-4 py-2 flex items-center justify-between">
      <h3 class="font-semibold">Video Upload Queue</h3>
    </div>

    <div class="p-4 flex items-center space-x-4">
      <div class="flex items-center w-full justify-start gap-4">
        <div class="w-[30%] h-14 shrink-0">
          <img class="w-full h-full object-cover shrink-0" :src="videoQueueStore.tempThumbnail" />
        </div>
        <div class="w-[70%] h-full flex gap-4 items-start justify-start">
          <div class="flex w-[90%] flex-col gap-1 truncate">
            <p class="text-black w-[230px] truncate font-semibold">
              {{ videoQueueStore.tempVideoTitle }}
            </p>
            <div class="flex gap-2">
              <div
                class="h-[26px] rounded-full p-2 flex items-center justify-center cursor-pointer bg-primary text-white"
              >
                <p class="text-[11px] font-bold">{{ videoQueueStore.tempWorkoutLevel }}</p>
              </div>
              <div
                class="h-[26px] rounded-full p-2 flex items-center justify-center cursor-pointer bg-primary text-white"
              >
                <p class="text-[11px] font-bold">{{ videoQueueStore.tempDuration }}</p>
              </div>
            </div>
          </div>
          <div
            v-if="videoQueueStore.uploadLoadingVideoQueue"
            class="h-[20px] w-[10%] ml-auto my-auto"
          >
            <Loading />
          </div>
          <div v-else class="h-[20px] w-[10%] ml-auto my-auto">
            <CircleCheck stroke-width="3" class="text-primary w-[18px] h-[18px] font-semibold" />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.box-shadow {
  box-shadow: rgba(0, 0, 0, 0.3) 0px 4px 16px;
}
</style>
