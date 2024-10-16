<script setup>
import { Button } from '@common/ui/button'
</script>
<template>
  <div class="flex flex-col items-center justify-center h-screen">
    <h1 class="text-6xl font-bold text-primary mb-4">404</h1>
    <p class="text-xl text-black">Page Not Found</p>
    <router-link to="/">
      <Button variant="default" class="uppercase mt-3">Back to home</Button>
    </router-link>
  </div>
</template>
