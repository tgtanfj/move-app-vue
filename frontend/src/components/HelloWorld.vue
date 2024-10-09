<script setup>
import ForgotPassword from './ForgotPassword.vue'
</script>

<template>
  <h1 class="flex justify-center text-primary-hello items-center h-screen">
    {{ $t('common.hello_world') }}
    <ForgotPassword />
  </h1>
</template>
