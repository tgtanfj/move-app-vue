<script setup>
import FollowingUser from './FollowingUser.vue'
import SocialLink from './SocialLink.vue'
import { ref } from 'vue'

const listFollowingUser = ref([
  {
    name: 'DinaeTV',
    follower: 1231,
    avatar: ''
  },
  {
    name: 'A',
    follower: 1231,
    avatar: ''
  },
  {
    name: 'acb',
    follower: 1231,
    avatar: ''
  },
  {
    name: 'acb',
    follower: 1231,
    avatar: ''
  },
  {
    name: 'acb',
    follower: 1231,
    avatar: ''
  }
])

const listSocialNetwork = ref({
  facebook: 'https://www.facebook.com/mancity',
  instagram: 'https://www.instagram.com/',
  youtube: 'https://www.youtube.com/'
})

const aboutDesc = ref(
  'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem'
)
</script>
<template>
  <div class="flex gap-5 w-[90%] mb-6">
    <!-- ABOUT DESCRIPTION -->
    <div class="bg-black p-4 rounded-lg text-white basis-4/5">
      <h4 class="text-xl font-bold mb-2">About Diane</h4>
      <p class="leading-5" v-if="aboutDesc">
        Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor
        invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam
        et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est
        Lorem
      </p>
      <p class="italic" v-else>No information found</p>
    </div>

    <!-- SOCIAL NETWORK-->
    <div>
      <h4 class="text-xl font-bold mb-4">Social Network</h4>
      <div class="flex gap-3" v-if="Object.keys(listSocialNetwork).length">
        <SocialLink
          v-for="(link, title) in listSocialNetwork"
          :key="title"
          :title="title"
          :link="link"
        />
      </div>
      <p v-else class="italic">No social network found.</p>
    </div>
  </div>

  <!-- FOLLOWING -->
  <div v-if="listFollowingUser?.length > 0">
    <h2 class="font-bold text-title-size mb-16">Diane is following</h2>
    <div class="grid grid-cols-4 gap-y-12">
      <FollowingUser
        v-for="u in listFollowingUser"
        :key="u"
        :name="u.name"
        :follower="u.follower"
        :avatar="u.avatar"
      />
    </div>
  </div>
</template>
