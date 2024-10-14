<script setup>
import SeparatorCross from '@components/SeparatorCross.vue'
import SliderHomePage from './SliderHomePage.vue'
import SeparatorCrossWithoutTitle from '@components/SeparatorCrossWithoutTitle.vue'
import Category from './Category.vue'
import VideosMayYouLike from './VideosMayYouLike.vue'
</script>

<template>
  <div class="w-full h-full transition-all">
    <div class="w-[90%] m-6">
      <SeparatorCross :title="$t('homepage.featured')" />
      <div class="w-[85%] m-auto h-[300px]">
        <SliderHomePage />
      </div>
      <SeparatorCrossWithoutTitle class="pt-14" />
      <div class="w-full">
        <Category />
      </div>
      <SeparatorCrossWithoutTitle class="pt-14" />
      <div class="w-full">
        <!-- <VideosMayYouLike /> -->
      </div>
    </div>
  </div>
</template>
