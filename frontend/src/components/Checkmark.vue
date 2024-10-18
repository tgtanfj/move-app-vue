<script setup>
import { Check } from 'lucide-vue-next'

const props = defineProps({
  width: {
    type: Number,
    required: true
  },
  height: {
    type: Number,
    required: true
  }
})
</script>

<template>
  <div
    class="ml-3 bg-[#0AB5E7] rounded-full flex items-center justify-center"
    :style="{ width: `${props.width}px`, height: `${props.height}px` }"
  >
    <Check color="#ffffff" size="14" />
  </div>
</template>
