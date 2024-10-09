<script setup>
import HomePageSidebar from '@components/home/HomePageSidebar.vue'
import { ref } from 'vue'

const sidebarOpen = ref(true)

const toggleSidebar = () => {
  sidebarOpen.value = !sidebarOpen.value
}
</script>

<template>
  <div class="w-full h-full">
    <HomePageSidebar :sidebarOpen="sidebarOpen" @toggleSidebar="toggleSidebar" />
    <div
      class="w-full h-full transition-all "
      :class="{ 'pl-[240px]': sidebarOpen, 'pl-[65px]': !sidebarOpen }"
    >
      <router-view />
    </div>
  </div>
</template>
