<script setup>
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@common/ui/select'
import { ref } from 'vue'
const props = defineProps({
  label: {
    type: String,
    required: false
  },
  listItems: {
    type: Array,
    required: true
  }
})

const emit = defineEmits(['update:value'])
const selectedValue = ref(null)

const onSelect = (value) => {
  selectedValue.value = value
  emit('update:value', value)
}
</script>
<template>
  <div class="flex items-center gap-5">
    <p class="uppercase font-bold">{{ label }}</p>
    <Select v-model="selectedValue" @update:modelValue="onSelect">
      <SelectTrigger class="w-44 border-primary text-primary py-6">
        <SelectValue v-if="label === 'category'" placeholder="All categories" />
        <SelectValue v-else :placeholder="listItems[0].title" />
      </SelectTrigger>
      <SelectContent class="border-primary text-primary overflow-y-auto max-h-[220px]">
        <SelectItem value="0" v-if="label === 'category'">All categories</SelectItem>
        <SelectItem v-for="item in listItems" :value="item.value || item.id.toString()">
          <span class="">{{ item.title }}</span></SelectItem
        >
      </SelectContent>
    </Select>
  </div>
</template>
