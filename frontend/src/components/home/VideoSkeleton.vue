<script setup>
import { Skeleton } from '@common/ui/skeleton'
</script>

<template>
  <div class="flex flex-col">
    <div class="aspect-w-1 aspect-h-1 h-[170px] relative">
      <Skeleton class="w-full h-[170px]" />
      <div
        class="absolute bottom-4 left-4 text-white bg-black text-[12px] flex items-center gap-2 px-2 rounded-md"
      >
        <Skeleton class="" />
      </div>
    </div>
    <div class="flex items-start mt-2">
      <Skeleton class="w-[32px] h-[32px] rounded-full" />
      <div class="ml-3">
        <Skeleton class="w-full h-[16px]" />
        <div class="flex flex-col items-start justify-start mt-1.5">
            <Skeleton class="w-full h-[16px]" />
          <div class="flex gap-1 items-center">
            <Skeleton class="w-full h-[16px]" />
          </div>
          <div class="flex items-center gap-1 justify-start mt-2">
            <Skeleton class="h-[35px] w-[74px] rounded-full" />
            <Skeleton class="h-[35px] w-[94px] rounded-full" />
          </div>
        </div>
      </div>
      <div class="flex items-center gap-1 ml-auto mt-[5px]">
        <Skeleton class="w-full h-[30px]" />
      </div>
    </div>
  </div>
</template>
