<script setup>
import { Button } from '@common/ui/button'
import { ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import Heart from '../../assets/icons/Heart.vue'
import HeartFilled from '../../assets/icons/HeartFilled.vue'
import { useFollow, useUnfollow } from '../../services/follow.services'
import { useAuthStore } from '../../stores/auth'
import { useFollowerStore } from '../../stores/follower.store'
import { useOpenLoginStore } from '../../stores/openLogin'
import { useChannelStore } from '../../stores/view-channel'

const emit = defineEmits(['increaseFollower', 'decreaseFollower'])

const route = useRoute()
const id = route.params.id

const channelStore = useChannelStore()
const openLoginStore = useOpenLoginStore()
const userStore = useAuthStore()
const followerStore = useFollowerStore()

const isFollowed = ref(channelStore.channelInfo.isFollowed)
const canFollow = ref(channelStore.channelInfo.canFollow)
const mutationFollow = useFollow()
const mutationUnfollow = useUnfollow()

watch(
  () => channelStore.channelInfo,
  () => {
    isFollowed.value = channelStore.channelInfo.isFollowed
    canFollow.value = channelStore.channelInfo.canFollow
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
            followerStore.getAllFollowers()
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
            followerStore.getAllFollowers()
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
      <Button variant="link" @click="handleFollow" v-if="canFollow !== false">
        <HeartFilled v-show="isFollowed" />
        <Heart v-show="!isFollowed" />
        <span class="ml-3 font-bold uppercase">{{ $t('view_channel.follow') }}</span></Button
      >
    </div>
  </div>
</template>
