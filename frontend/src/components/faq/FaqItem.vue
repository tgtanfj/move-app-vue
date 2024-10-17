<script setup>
import { Minus, Plus } from 'lucide-vue-next'
import { ref } from 'vue'

const props = defineProps({
  item: {
    type: Object,
    required: true
  }
})

const showAnswer = ref(false)

const toggle = () => {
  showAnswer.value = !showAnswer.value
}
</script>
<template>
  <div class="pl-5 border-2 border-gray-100 shadow-md rounded-xl my-7 p-4">
    <div @click="toggle" class="flex justify-between items-center cursor-pointer">
      <h2 class="text-xl font-bold" :class="{ 'text-primary': showAnswer }">
        {{ item.question }}
      </h2>
      <span class="text-gray-500">
        <Plus :size="30" color="#000000" v-if="!showAnswer"/>
      </span>
    </div>
    <div class="flex justify-between" v-if="showAnswer">
      <p class="pr-5 mt-4 text-gray-700 text-base">{{ item.answer }}</p>
      <div class="cursor-pointer mt-[-25px]" @click="showAnswer = false">
        <Minus :size="30" color="#12bda3" />
      </div>
    </div>
  </div>
</template>
<style scoped></style>
