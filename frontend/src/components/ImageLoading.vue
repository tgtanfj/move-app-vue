<script setup></script>

<template>
  <div class="w-[160px] h-[90px] bg-[#EDEDED] flex items-center justify-center">
    <div class="spinner"></div>
  </div>
</template>

<style scoped>
.spinner {
  width: 25px;
  height: 25px;
  border: 4px solid #cccccc;
  border-top-color: transparent;
  border-radius: 50%;
  animation: spin 1s ease-in-out infinite;
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}
</style>
