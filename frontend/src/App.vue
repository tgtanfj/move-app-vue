<script setup>
import Toaster from '@common/ui/toast/Toaster.vue'
import ToastProvider from '@common/ui/toast/ToastProvider.vue'
import Navbar from '@components/Navbar.vue'
import ResetPasswordView from '@views/ResetPasswordView.vue';
import { RouterView } from 'vue-router'
</script>

<template>
  <ToastProvider>
    <Navbar />

    <RouterView />
    <Toaster />
  </ToastProvider>
</template>
