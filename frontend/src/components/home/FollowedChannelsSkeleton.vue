<script setup lang="ts">
import { Skeleton } from '@common/ui/skeleton'
</script>

<template>
  <div class="flex flex-col w-full">
    <div class="flex items-center gap-1 w-full">
      <Skeleton class="w-[40px] h-[40px] rounded-full" />
      <div class="flex flex-col gap-1 flex-1">
        <div class="flex items-center justify-start gap-2">
          <span class="ml-0 text-sm text-nowrap"></span>
          <Skeleton class="w-[50%] h-[20px]" />
          <Skeleton class="w-[20px] h-[20px] rounded-full" />
          <Skeleton class="w-[20px] h-[20px] rounded-full" />
        </div>
        <div class="ml-2">
          <Skeleton class="w-[30%] h-[20px]" />
        </div>
      </div>
    </div>
  </div>
</template>
