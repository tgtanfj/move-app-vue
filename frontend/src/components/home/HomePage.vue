<script setup>
import SeparatorCross from '@components/SeparatorCross.vue'
import SeparatorCrossWithoutTitle from '@components/SeparatorCrossWithoutTitle.vue'
import Category from './Category.vue'
import VideosMayYouLike from './VideosMayYouLike.vue'
import SliderHompageNextGen from './SliderHompageNextGen.vue'
import SliderHomePage from './SliderHomePage.vue'
</script>

<template>
  <div class="w-full h-full transition-all">
    <div class="w-[90%] m-6">
      <SeparatorCross :title="$t('homepage.featured')" />
      <div class="w-[95%] m-auto">
        <!-- <SliderHompageNextGen /> -->
        <SliderHomePage/>
      </div>
      <SeparatorCrossWithoutTitle class="pt-14" />
      <div class="w-full">
        <Category />
      </div>
      <SeparatorCrossWithoutTitle class="pt-14" />
      <div class="w-full">
        <VideosMayYouLike />
      </div>
    </div>
  </div>
</template>
