<script setup>
import { ChevronLeft } from "lucide-vue-next";
import { useCarousel } from "./useCarousel";
import { cn } from "@utils/shadcn.util";
import { Button } from "@common/ui/button";

const props = defineProps({
  class: { type: null, required: false },
});

const { orientation, canScrollPrev, scrollPrev } = useCarousel();
</script>

<template>
  <Button
    :disabled="!canScrollPrev"
    :class="
      cn(
        'touch-manipulation absolute h-8 w-8 rounded-full p-0',
        orientation === 'horizontal'
          ? '-left-12 top-1/2 -translate-y-1/2'
          : '-top-12 left-1/2 -translate-x-1/2 rotate-90',
        props.class,
      )
    "
    variant="outline"
    @click="scrollPrev"
  >
    <slot>
      <ChevronLeft class="h-6 w-6 text-black font-bold hover:text-primary"/>
    </slot>
  </Button>
</template>
