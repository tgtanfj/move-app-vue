<script setup>
import { exampleService } from '@services/example.services'

const exampleData = exampleService.getPhotos()
</script>

<template>
  <h1 class="flex justify-center text-primary-hello items-center h-screen">
    {{ $t('common.hello_world') }}
  </h1>
</template>
