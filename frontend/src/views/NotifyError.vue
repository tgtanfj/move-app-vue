<script setup>
import Button from '@common/ui/button/Button.vue';
import { useRouter } from 'vue-router';

const router = useRouter()

const goBackHome = () => {
  router.push('/')
}
</script>

<template>
  <div class="flex flex-col justify-center items-center gap-5 h-screen">
    <p class="text-2xl font-semibold">Sorry, this notification doesn't exist</p>
    <p class="text-lg font-medium text-center">The notification you just clicked may have a broken link or the content of this page has been removed.</p>
    <Button @click="goBackHome" class="text-lg"> GO TO HOME </Button>
  </div>
</template>
