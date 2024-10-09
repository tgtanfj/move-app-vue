<script setup>
import FaqSidebar from '../components/FaqSidebar.vue'
</script>

<template>
  <div class="flex">
    <FaqSidebar />
    <div class="content grow">
      <router-view />
    </div>
  </div>
</template>
