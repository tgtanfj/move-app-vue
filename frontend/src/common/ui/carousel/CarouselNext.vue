<script setup>
import { ChevronRight } from 'lucide-vue-next'
import { useCarousel } from './useCarousel'
import { cn } from '@utils/shadcn.util'
import { Button } from '@common/ui/button'

const props = defineProps({
  class: { type: null, required: false }
})

const { orientation, canScrollNext, scrollNext } = useCarousel()
</script>

<template>
  <Button
    :disabled="!canScrollNext"
    :class="
      cn(
        'touch-manipulation absolute h-8 w-8 rounded-full p-0',
        orientation === 'horizontal'
          ? '-right-12 top-1/2 -translate-y-1/2'
          : '-bottom-12 left-1/2 -translate-x-1/2 rotate-90',
        props.class
      )
    "
    variant="outline"
    @click="scrollNext"
  >
    <slot>
      <ChevronRight class="h-6 w-6 text-black font-bold hover:text-primary" />
    </slot>
  </Button>
</template>
