<script setup>
import { useAuthStore } from '../../stores/auth'
import { Star, X } from 'lucide-vue-next'
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
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

const ratingModal = ref(null)

const emit = defineEmits('update-rating')

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
        const res = await apiAxios.get(`/video/${videoId}/details`)
        if (res.status === 200) {
          emit('update-rating', res.data.data.ratings)
        } else throw new Error('Error when getting ratings')
      } else throw new Error(response.error)
    } catch (error) {
      console.error(error)
    } finally {
      showRatingModal.value = false
    }
  }
}
const cancel = () => {
  showRatingModal.value = false
  if (!oldRating.value) rating.value = 0
  else rating.value = oldRating.value
}
const openPopover = () => {
  if (authStore.accessToken) {
    showRatingModal.value = true
  } else {
    openLoginStore.toggleOpenLogin()
  }
}
</script>
<template>
  <Popover
    v-model:open="showRatingModal"
    @update:open="
      (val) => {
        if (!val) cancel()
      }
    "
    ref="ratingModal"
  >
    <PopoverTrigger class="flex gap-2 items-center text-primary" @click="openPopover">
      <Star width="24px" color="#12BDA3" :fill="oldRating > 0 ? '#12BDA3' : '#ffffff'" />
      <span class="uppercase font-semibold text-sm"> {{ $t('video.rate') }}</span>
    </PopoverTrigger>
    <PopoverContent side="top" align="end" :class="{ hidden: !showRatingModal }">
      <div class="flex justify-between items-center">
        <h4 class="font-bold text-lg">{{ $t('video.rate_video') }}</h4>
        <X class="cursor-pointer" @click="cancel" />
      </div>
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
            <!-- <Button @click="cancel" variant="outline">{{ $t('button.cancel') }}</Button> -->
            <Button
              @click="onSubmit"
              :disabled="rating === 0 || oldRating === rating"
              :class="{ 'bg-gray-400': rating === 0 || oldRating === rating }"
              >{{ $t('button.submit') }}</Button
            >
          </div>
        </div>
      </div>
    </PopoverContent>
  </Popover>
</template>
