<script setup> 
const props = defineProps({
  videoUrl: {
    type: String,
    required: true
  }
})

</script>
<template>
  <div class="relative w-full pb-[56.25%] h-0 overflow-hidden">
    <iframe
      :src="props.videoUrl"
      class="absolute top-0 left-0 w-full h-full"
      frameborder="0"
      allow="autoplay; fullscreen"
    >
    </iframe>
  </div>
</template>
