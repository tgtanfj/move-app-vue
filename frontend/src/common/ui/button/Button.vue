<script setup>
import { cn } from '@utils/shadcn.util'
import { Primitive } from 'radix-vue'
import { buttonVariants } from '.'

const props = defineProps({
  variant: { type: null, required: false },
  size: { type: null, required: false },
  class: { type: null, required: false },
  asChild: { type: Boolean, required: false },
  as: { type: null, required: false, default: 'button' },
  isLoading: { type: Boolean, required: false }
})
</script>

<template>
  <Primitive
    :as="as"
    :as-child="asChild"
    :class="cn(buttonVariants({ variant, size }), props.class)"
  >
    <template v-if="isLoading"> {{ $t('button.loading') }} </template>
    <template v-else>
      <slot />
    </template>
  </Primitive>
</template>
