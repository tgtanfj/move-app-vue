<script setup>
import Categories from '@components/home/Categories.vue'
import CategorySkeleton from '@components/home/CategorySkeleton.vue'
import SeparatorCross from '@components/SeparatorCross.vue'
import { homepageService } from '@services/homepage.services'
import { onMounted, ref } from 'vue'

const categoriesData = ref(null)

onMounted(async () => {
  const response = await homepageService.getAllCategories()
  if (response.message === 'success') {
    categoriesData.value = response?.data
  }
})
</script>

<template>
  <div class="p-6 w-[90%]">
    <SeparatorCross :title="$t('homepage.categories')" />
    <div v-if="categoriesData" class="w-full grid grid-cols-6 gap-3 mt-4">
      <div v-for="(item, index) in categoriesData" class="flex flex-col cursor-pointer">
        <Categories :category="item" :key="index" />
      </div>
    </div>
    <div v-if="!categoriesData" class="w-full grid grid-cols-6 gap-3 mt-4">
      <div v-for="item in 24" class="flex flex-col cursor-pointer">
        <CategorySkeleton />
      </div>
    </div>
  </div>
</template>
