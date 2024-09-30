<template>
  <div class="relative w-full max-w-3xl mx-auto mt-3">
    <div class="overflow-hidden">
      <div class="overflow-hidden">
        <div
          class="flex transition-transform duration-300 ease-in-out"
          :style="{ transform: `translateX(-${currentIndex * 50}%)` }"
        >
          <div v-for="(slide, index) in slides" :key="index" class="w-1/2 flex-shrink-0 px-1">
            <div class="aspect-video bg-gray-200 rounded-md flex items-center justify-center">
              <span class="text-2xl font-semibold text-gray-700">{{ slide }}</span>
            </div>
          </div>
        </div>
      </div>

      <button
        @click="prev"
        :class="{ hidden: currentIndex === 0 }"
        class="absolute left-0 top-1/2 -translate-y-1/2 w-6 h-12 flex items-center justify-center bg-black rounded-sm shadow-md focus:outline-none"
        aria-label="Previous slide"
      >
        <ChevronLeft class="w-6 h-6 text-white" />
      </button>

      <button
        @click="next"
        class="absolute right-0 top-1/2 -translate-y-1/2 w-6 h-12 flex items-center justify-center bg-black rounded-sm shadow-md focus:outline-none"
        aria-label="Next slide"
      >
        <ChevronRight class="w-6 h-6 text-white" />
      </button>
    </div>
  </div>
</template>

<script setup>
import { ChevronLeft } from 'lucide-vue-next'
import { ChevronRight } from 'lucide-vue-next'
import { computed, ref } from 'vue'
const slides = ['Slide 1', 'Slide 2', 'Slide 3', 'Slide 4', 'Slide 5']
const currentIndex = ref(0)

const next = () => {
  if (currentIndex.value < slides.length - 2) {
    currentIndex.value++
  }
}

const prev = () => {
  if (currentIndex.value > 0) {
    currentIndex.value--
  }
}
</script>
