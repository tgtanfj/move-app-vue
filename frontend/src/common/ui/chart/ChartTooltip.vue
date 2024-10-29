<script setup>
import {
  Card,
  CardContent,
} from '@common/ui/card';

defineProps({
  title: { type: String, required: false },
  data: { type: Array, required: true },
});
</script>

<template>
  <Card class="text-sm">
    <CardContent class="p-2 min-w-[100px]">
      <div v-for="(item, key) in data" :key="key">
        <div class="font-semibold text-center">{{ item.value }} people</div>
      </div>
    </CardContent>
  </Card>
</template>
