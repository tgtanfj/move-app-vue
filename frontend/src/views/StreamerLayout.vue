<template>
  <div class="flex">
    <Sidebar />
    <div class="content grow">
      <router-view />
    </div>
  </div>
</template>

<script setup>
import Sidebar from '@components/Sidebar.vue'
</script>
