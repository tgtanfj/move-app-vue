<script setup>
import SeparatorCross from '@components/SeparatorCross.vue'
import { formatUrlToCategoryTitle } from '@utils/formatCategoryTitle.util'
import { ref } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()

const categoryTitle = ref(formatUrlToCategoryTitle(route.params.title))
</script>

<template>
  <div class="w-full h-full">
    <div class="w-full h-full">
      <div class="w-[90%] h-full p-6">
        <SeparatorCross :title="categoryTitle" />
      </div>
    </div>
  </div>
</template>
