<template>
  <div class="flex justify-center items-center p-0 m-0">
    <div class="spinner"></div>
  </div>
</template>

<style scoped>
.spinner {
  width: 16px;
  height: 16px;
  border: 4px solid white;
  border-top-color: #10d0b6;
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
