<template>
  <Card class="w-[30%] shadow-2xl">
    <CardHeader>
      <CardTitle class="mb-2">{{ title }}</CardTitle>
      <CardDescription>{{ description }}</CardDescription>
    </CardHeader>
    <CardContent> <slot /> </CardContent>
  </Card>
</template>

<script setup>
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/common/ui/card'

const props = defineProps({
  title: {
    type: String,
    default: 'Default Title'
  },
  description: {
    type: String,
    default: 'Card Description'
  }
})
</script>
