<script setup>
const props = defineProps({
  title: {
    type: String,
    default: 'Title'
  }
})
</script>

<template>
  <div class="flex w-full items-center gap-9">
    <p class="text-2xl font-bold text-secondary text-nowrap">{{ title }}</p>
    <div class="relative w-full h-3 bg-black overflow-hidden">
      <div class="-top-3 left-4 absolute w-2 h-8 bg-white rotate-45"></div>
      <div class="-top-3 left-10 absolute w-2 h-8 bg-white rotate-45"></div>
      <div class="-top-3 left-16 absolute w-2 h-8 bg-white rotate-45"></div>
      <div class="-top-3 left-[78px] absolute w-2 h-8 bg-white rotate-45"></div>
    </div>
  </div>
</template>
