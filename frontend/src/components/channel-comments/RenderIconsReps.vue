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
      src="../../assets/icons/GrayIconImg.png"
    />
    <img
      v-else-if="numberOfReps <= 4999"
      class="w-[14px] h-[20px] shrink-0"
      src="../../assets/icons/GreenIconImg.png"
    />
    <img
      v-else-if="numberOfReps <= 9999"
      class="w-[14px] h-[20px] shrink-0"
      src="../../assets/icons/PinkIconImg.png"
    />
    <img
      v-else-if="numberOfReps <= 24999"
      class="w-[14px] h-[20px] shrink-0"
      src="../../assets/icons/BlueIconImg.png"
    />
    <img v-else class="w-[14px] h-[20px] shrink-0" src="../../assets/icons/YellowIconImg.png" />
  </div>
</template>
