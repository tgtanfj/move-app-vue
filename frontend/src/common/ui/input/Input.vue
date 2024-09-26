<script setup>
import { cn } from '@utils/shadcn.util'
import { useVModel } from '@vueuse/core'

const props = defineProps({
  defaultValue: { type: [String, Number], required: false },
  modelValue: { type: [String, Number], required: false },
  class: { type: null, required: false }
})

const emits = defineEmits(['update:modelValue'])

const modelValue = useVModel(props, 'modelValue', emits, {
  passive: true,
  defaultValue: props.defaultValue
})
</script>

<template>
  <input
    v-model="modelValue"
    :class="
      cn(
        'flex h-10 w-full text-[16px] mb-1 py-2 px-3 border-darkGray border-[1px] rounded-lg focus:border-[#13D0B4] focus:outline-none',
        props.class
      )
    "
  />
</template>
