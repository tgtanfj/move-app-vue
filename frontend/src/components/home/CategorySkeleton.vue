<script setup>
import { Skeleton } from '@common/ui/skeleton'
</script>

<template>
  <div>
    <div class="mb-2">
      <Skeleton class="h-[220px] w-full aspect-w-1 aspect-h-1" />
    </div>
    <Skeleton class="w-[100px] h-[25px] mb-2" />
    <Skeleton class="w-[80px] h-[14px]" />
  </div>
</template>
