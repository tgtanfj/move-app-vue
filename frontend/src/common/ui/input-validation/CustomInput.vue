<template>
  <div class="flex flex-col space-y-1.5 mb-4">
    <label v-if="label" :for="name">{{ label }}</label>
    <input
      :type="inputType"
      v-bind="inputBinds"
      :id="name"
      class="text-[16px] mb-1 py-2 px-3 border-darkGray border-[1px] rounded-lg focus:border-primary focus:outline-none"
    />
    <ErrorMessage :name="name" class="text-redMisc text-sm italic" />
  </div>
</template>

<script setup>
import { ErrorMessage } from 'vee-validate'
const props = defineProps({
  label: {
    type: [String, Boolean],
    default: false,
    required: false
  },
  inputType: {
    type: String,
    default: 'text'
  },
  name: {
    type: String,
    required: true
  },
  defineInputBinds: {
    type: Function,
    required: true
  },
  errorBag: {
    type: Object,
    required: true
  }
})

const inputBinds = props.defineInputBinds(props.name)
</script>
