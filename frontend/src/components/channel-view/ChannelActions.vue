<script setup>
import { Button } from '@common/ui/button'
import { Heart, Share2, EllipsisVertical } from 'lucide-vue-next'
</script>
<template>
  <div class="flex gap-4">
    <div>
      <Button variant="link"
        ><Heart className="h-4 w-4" /> <span class="ml-3 font-bold uppercase">Follow</span></Button
      >
      <Button variant="link"
        ><Share2 className="h-4 w-4" /> <span class="ml-3 font-bold uppercase">Share</span></Button
      >
      <Button variant="link"><EllipsisVertical /> </Button>
    </div>
  </div>
</template>
