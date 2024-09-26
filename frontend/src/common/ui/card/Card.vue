<script setup>
import { cn } from '@utils/shadcn.util'

const props = defineProps({
  class: { type: null, required: false }
})
</script>

<template>
  <div
    :class="
      cn('rounded-lg border bg-card text-card-foreground shadow-sm m-auto mt-20', props.class)
    "
  >
    <slot />
  </div>
</template>
