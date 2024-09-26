<script setup>
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle
} from '@common/ui/dialog'

const props = defineProps({
  title: {
    type: String,
    default: ''
  },
  description: {
    type: String,
    default: ''
  },
  open: {
    type: Boolean,
    default: false
  }
})

// const emit = defineEmits(['update:open'])

const open = defineModel('open', {
  type: Boolean,
  default: false
})
</script>

<template>
  <Dialog v-model:open="open">
    <DialogContent class="max-w-[568px]">
      <DialogHeader v-if="title">
        <DialogTitle>{{ title }}</DialogTitle>
        <DialogDescription>
          {{ description }}
        </DialogDescription>
      </DialogHeader>
      <slot />
    </DialogContent>
  </Dialog>
</template>

<style scoped></style>
