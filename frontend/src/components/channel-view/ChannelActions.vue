<script setup>
import { Button } from '@common/ui/button'
import { EllipsisVertical, Share2 } from 'lucide-vue-next'
import { ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import Heart from '../../assets/icons/Heart.vue'
import HeartFilled from '../../assets/icons/HeartFilled.vue'
import { useFollow, useUnfollow } from '../../services/follow.services'
import { useAuthStore } from '../../stores/auth'
import { useOpenLoginStore } from '../../stores/openLogin'
import { useChannelStore } from '../../stores/view-channel'

const emit = defineEmits(['increaseFollower', 'decreaseFollower'])

const route = useRoute()
const id = route.params.id

const channelStore = useChannelStore()
const openLoginStore = useOpenLoginStore()
const userStore = useAuthStore()

const isFollowed = ref(channelStore.channelInfo.isFollowed)
const mutationFollow = useFollow()
const mutationUnfollow = useUnfollow()

watch(
  () => channelStore.channelInfo,
  () => {
    isFollowed.value = channelStore.channelInfo.isFollowed
  }
)

const handleFollow = () => {
  const isLogin = !!userStore.accessToken

  if (isLogin) {
    if (isFollowed.value) {
      mutationUnfollow.mutate(
        {
          channelId: +id
        },
        {
          onSuccess: () => {
            isFollowed.value = false
            emit('decreaseFollower')
          }
        }
      )
    } else {
      mutationFollow.mutate(
        {
          channelId: +id
        },
        {
          onSuccess: () => {
            isFollowed.value = true
            emit('increaseFollower')
          }
        }
      )
    }
  } else {
    openLoginStore.toggleOpenLogin()
  }
}
</script>
<template>
  <div class="flex gap-4">
    <div>
      <Button variant="link" @click="handleFollow">
        <HeartFilled v-show="isFollowed" />
        <Heart v-show="!isFollowed" />
        <span class="ml-3 font-bold uppercase">{{ $t('view_channel.follow') }}</span></Button
      >
      <Button variant="link"
        ><Share2 className="h-4 w-4" />
        <span class="ml-3 font-bold uppercase">{{ $t('view_channel.share') }}</span></Button
      >
      <Button variant="link"><EllipsisVertical /> </Button>
    </div>
  </div>
</template>
