<script setup>
import { useAuthStore } from '../../stores/auth'
import { Star } from 'lucide-vue-next'
import { onMounted, ref, watch } from 'vue'
import { Button } from '@common/ui/button'
import { apiAxios } from '@helpers/axios.helper'
import { useRoute } from 'vue-router'
import { useOpenLoginStore } from '../../stores/openLogin'
import { useToast } from '@common/ui/toast/use-toast'
import { Popover, PopoverContent, PopoverTrigger } from '@common/ui/popover'

const authStore = useAuthStore()
const openLoginStore = useOpenLoginStore()
const { toast } = useToast()
const route = useRoute()
const videoId = route.params.id
const oldRating = ref(0)
const rating = ref(0)
const showRatingModal = ref(false)

watch(
  () => authStore.accessToken,
  async (newValue) => {
    if (newValue) {
      try {
        const response = await apiAxios.get(`/watching-video-history/${videoId}/rate`)
        if (response.status === 200) {
          if (response.data.data) {
            rating.value = response.data.data.rate
            oldRating.value = response.data.data.rate
          } else {
            rating.value = 0
          }
        }
      } catch (error) {
        console.log(error)
      }
    }
  },
  { immediate: true }
)

const setRating = (index) => {
  rating.value = index
}
const onSubmit = async () => {
  if (!authStore.accessToken) {
    openLoginStore.toggleOpenLogin()
  } else {
    if (oldRating.value === rating.value) return
    else {
      try {
        const response = await apiAxios.patch(`/watching-video-history/rate`, {
          rate: rating.value,
          videoId: Number(videoId)
        })
        if (response.status === 200) {
          toast({ description: 'Thanks you for your ratings', variant: 'successfully' })
          oldRating.value = rating.value
        } else throw new Error(response.error)
      } catch (error) {
        console.log(error)
      } finally {
        showRatingModal.value = false
      }
    }
  }
}
const cancel = () => {
  showRatingModal.value = false
}
</script>
<template>
  <div class="relative flex items-center gap-2 text-sm font-semibold text-primary cursor-pointer">
    <Popover v-model:open="showRatingModal">
      <PopoverTrigger class="flex gap-2 items-center">
        <Star width="24px" class="text-primary" />
        <span class="uppercase font-semibold text-sm">{{ $t('video.rate') }}</span>
      </PopoverTrigger>
      <PopoverContent
        class="min-w-[300px] flex flex-col bg-white p-7 text-black rounded-lg shadow-lg border-1 border-gray-200 z-10"
      >
        <h4 class="font-bold text-lg">{{ $t('video.rate_video') }}</h4>
        <p class="text-base mt-2">{{ $t('video.rate_description') }}</p>
        <div class="mt-2">
          <div class="flex flex-col gap-2">
            <div class="flex">
              <Star
                color="#12BDA3"
                class="cursor-pointer"
                :fill="index <= rating ? '#12BDA3' : '#ffffff'"
                v-for="index in 5"
                :key="index"
                @click="setRating(index)"
              />
            </div>
            <div class="mt-3 flex gap-2 justify-end">
              <Button @click="cancel" variant="outline">{{ $t('button.cancel') }}</Button>
              <Button
                @click="onSubmit"
                :disabled="rating === 0 || oldRating === rating"
                :class="{ 'bg-gray-400': rating === 0 || oldRating === rating }"
                >{{ $t('button.rate') }}</Button
              >
            </div>
          </div>
        </div>
      </PopoverContent>
    </Popover>
  </div>
</template>
