<script setup>
import { cn } from "@utils/shadcn.util";

const props = defineProps({
  class: { type: null, required: false },
});
</script>

<template>
  <div class="relative w-full overflow-auto">
    <table :class="cn('w-full caption-bottom text-sm', props.class)">
      <slot />
    </table>
  </div>
</template>
