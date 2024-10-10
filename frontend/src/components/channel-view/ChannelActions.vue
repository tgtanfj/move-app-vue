<script setup>
import { Button } from '@common/ui/button'
import { EllipsisVertical, Heart, Share2 } from 'lucide-vue-next'
import HeartFilled from '../../assets/icons/HeartFilled.vue'
import { useChannelStore } from '../../stores/view-channel'

const channelStore = useChannelStore()
const { isFollowed } = channelStore.channelInfo
</script>
<template>
  <div class="flex gap-4">
    <div>
      <Button variant="link">
        <HeartFilled v-if="isFollowed" />
        <Heart className="h-4 w-4" v-else />
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
