<script setup>
import { Skeleton } from '@common/ui/skeleton'
</script>
<template>
  <div class="flex items-center justify-between">
    <div class="flex items-center">
      <Skeleton class="w-[56px] h-[56px] mr-5 rounded-full" />
      <div>
        <div class="flex items-center">
          <Skeleton class="w-60 h-5 mb-3" />
        </div>
        <Skeleton class="w-56 h-5" />
      </div>
    </div>
    <Skeleton class="w-40 h-5" />
  </div>
  <div class="flex grid-cols-3 gap-6 mt-10">
    <Skeleton class="w-80 h-80" />
    <Skeleton class="w-80 h-80" />
    <Skeleton class="w-80 h-80" />
  </div>
</template>