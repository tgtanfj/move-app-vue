<template>
  <div class="flex">
    <Sidebar />
    <div class="content flex ml-[241px] w-full">
      <router-view />
    </div>
  </div>
</template>

<script setup>
import Sidebar from '@components/Sidebar.vue'
</script>
