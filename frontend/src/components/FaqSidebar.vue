<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'

const router = useRoute()
const path = computed(() => router.path)
const sidebarList = [
  {
    name: 'About us',
    path: '/move/about-us'
  },
  {
    name: 'FAQ',
    path: '/move/faq'
  },
  {
    name: 'Community Guildlines',
    path: '/move/community-guildline'
  },
  {
    name: 'Term of Service',
    path: '/move/term-of-service'
  },
  {
    name: 'Privacy Policy',
    path: '/move/privacy-policy'
  }
]
</script>

<template>
  <div class="grid h-screen flex-none pt-[56px] w-[400px]">
    <ul class="h-full pl-16 mt-6">
      <li v-for="item in sidebarList" :key="item.name" class="my-5">
        <router-link
          :to="item.path"
          class="text-xl"
          :class="{ 'text-2xl font-bold': item.path === path }"
        >
          {{ item.name }}
        </router-link>
      </li>
    </ul>
  </div>
</template>
