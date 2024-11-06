<script setup>
const props = defineProps({
  numberOfReps: {
    type: Number,
    required: true
  }
})
</script>

<template>
  <div v-if="numberOfReps > 0">
    <img
      v-if="numberOfReps <= 999"
      class="w-[14px] h-[20px] shrink-0"
      src="../../assets/images/GrayIconImg.png"
    />
    <img
      v-else-if="numberOfReps <= 4999"
      class="w-[14px] h-[20px] shrink-0"
      src="../../assets/images/GreenIconImg.png"
    />
    <img
      v-else-if="numberOfReps <= 9999"
      class="w-[14px] h-[20px] shrink-0"
      src="../../assets/images/PinkIconImg.png"
    />
    <img
      v-else-if="numberOfReps <= 24999"
      class="w-[14px] h-[20px] shrink-0"
      src="../../assets/images/BlueIconImg.png"
    />
    <img v-else class="w-[14px] h-[20px] shrink-0" src="../../assets/images/YellowIconImg.png" />
  </div>
</template>
