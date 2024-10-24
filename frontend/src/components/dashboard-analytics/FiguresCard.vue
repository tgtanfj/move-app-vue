<script setup>
import { Card, CardContent, CardHeader, CardTitle } from '@/common/ui/card'

const props = defineProps({
  title: {
    type: String,
    default: 'Default title'
  },
  figures: {
    type: [String, Number],
    default: 0
  }
})
</script>
<template>
  <Card class="w-64 shadow-[0px_5px_10px_rgba(0,0,0,0.35)] mx-0 mt-0">
    <CardHeader class="p-5 pb-3">
      <CardTitle class="text-base">{{ title }}</CardTitle>
    </CardHeader>
    <CardContent class="pb-5">
      <p class="text-4xl font-bold tracking-wider">{{ figures }}</p>
    </CardContent>
  </Card>
</template>
