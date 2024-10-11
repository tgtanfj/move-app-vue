<script setup>
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@common/ui/select'
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
</script>
<template>
  <div class="flex items-center gap-5">
    <p class="uppercase font-bold">{{ label }}</p>
    <Select>
      <SelectTrigger class="w-40 border-primary text-primary py-6">
        <SelectValue :placeholder="listItems[0].title" />
      </SelectTrigger>
      <SelectContent class="border-primary text-primary overflow-y-auto max-h-[220px]">
        <SelectItem v-for="item in listItems" :value="item.value">
          <span class="">{{ item.title }}</span></SelectItem
        >
      </SelectContent>
    </Select>
  </div>
</template>
