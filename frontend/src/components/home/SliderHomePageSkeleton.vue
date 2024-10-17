<script setup>
import { Card, CardContent } from '@common/ui/card'
import { Skeleton } from '@common/ui/skeleton'
</script>

<template>
  <div class="p-1">
    <Card class="mt-5">
      <CardContent
        class="relative flex p-0 mt-0 pt-0 items-center h-[300px] w-full justify-center rounded-lg overflow-hidden"
      >
        <div class="flex-[0.65] h-full">
          <Skeleton class="w-full h-full" />
        </div>
        <div class="flex-[0.35] h-full flex flex-col items-center justify-center gap-2.5">
          <div class="flex items-start gap-3 w-[80%]">
            <Skeleton class="w-[56px] h-[56px] rounded-full" />
            <div class="flex items-start flex-col justify-start">
              <div class="flex gap-4 items-center mb-1">
                <Skeleton class="h-[20px] w-[100px]" />
                <Skeleton class="h-[20px] w-[20px] rounded-full" />
              </div>
              <div class="text-[#666666] text-[14px] gap-1 flex flex-col">
                <Skeleton class="h-[20px] w-[70px]" />
                <Skeleton class="h-[20px] w-[100px]" />
              </div>
              <div class="flex items-center gap-2 mt-1">
                <Skeleton class="h-[25px] w-[40px]" />
              </div>
            </div>
          </div>
          <div class="flex items-center justify-start w-[80%] gap-2">
            <Skeleton class="w-[80px] h-[35px] rounded-full" />
            <Skeleton class="w-[100px] h-[35px] rounded-full" />
          </div>
          <div class="w-[80%] text-[14px] text-[#666666] space-y-1 mt-2">
            <Skeleton class="w-full h-[15px]" />
            <Skeleton class="w-full h-[15px]" />
            <Skeleton class="w-[20%] h-[15px]" />
          </div>
        </div>
      </CardContent>
    </Card>
  </div>
</template>
