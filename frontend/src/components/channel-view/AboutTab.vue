<script setup>
import { useChannelStore } from '../../stores/view-channel'
import FollowingUser from './FollowingUser.vue'
import SocialLink from './SocialLink.vue'

const channelStore = useChannelStore()
const { bio, name, socialLinks, followingChannels } = channelStore.channelInfo
</script>
<template>
  <div class="flex gap-5 w-[90%] mb-6">
    <!-- ABOUT DESCRIPTION -->
    <div class="bg-black p-4 rounded-lg text-white basis-4/5">
      <h4 class="text-xl font-bold mb-2">{{ $t('view_channel.about') }} {{ name }}</h4>
      <p class="leading-5" v-if="bio">
        {{ bio }}
      </p>
      <p class="italic" v-else>{{ $t('view_channel.no_bio') }}</p>
    </div>

    <!-- SOCIAL NETWORK-->
    <div>
      <h4 class="text-xl font-bold mb-4">Social Network</h4>
      <div class="flex gap-3" v-if="socialLinks.length">
        <SocialLink v-for="item in socialLinks" :key="item" :title="item.name" :link="item.link" />
      </div>
      <p v-else class="italic">{{ $t('view_channel.no_social_network') }}</p>
    </div>
  </div>

  <!-- FOLLOWING -->
  <div v-if="followingChannels?.length > 0">
    <h2 class="font-bold text-title-size mb-16">{{ $t('view_channel.following', { name }) }}</h2>
    <div class="grid grid-cols-4 gap-y-12">
      <FollowingUser
        v-for="u in followingChannels"
        :key="u"
        :id="u.id"
        :name="u.name"
        :follower="u.numberOfFollowers"
        :avatar="u.image"
        :isPinkBadge="u.isPinkBadge"
        :isBlueBadge="u.isBlueBadge"
      />
    </div>
  </div>
</template>
