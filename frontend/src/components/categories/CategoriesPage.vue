<script setup>
import Categories from '@components/home/Categories.vue'
import CategorySkeleton from '@components/home/CategorySkeleton.vue'
import SeparatorCross from '@components/SeparatorCross.vue'
import { homepageService } from '@services/homepage.services'
import { onMounted, ref } from 'vue'

const categories = [
  {
    title: 'MMA',
    img: 'https://i.pinimg.com/564x/19/c9/7b/19c97b7797bf6cc27d8e4a77fcd5de69.jpg',
    id: 1,
    views: 99383
  },
  {
    title: 'HIIT',
    id: 2,
    img: 'https://i.pinimg.com/564x/d0/9b/ce/d09bce9b96b9f4ade416642865208217.jpg',
    views: 12301
  },
  {
    title: 'Just Move',
    id: 3,
    img: 'https://i.pinimg.com/564x/be/3e/3b/be3e3b6065e0d03c6ec7039488df3167.jpg',
    views: 13313
  },
  {
    title: 'Strength',
    id: 4,
    img: 'https://i.pinimg.com/564x/d2/88/6c/d2886cb2866af5f21c3e692e1d7ad279.jpg',
    views: 98989
  },
  {
    title: 'Yoga',
    id: 5,
    img: 'https://i.pinimg.com/564x/6b/85/9a/6b859a40ba40fcd812dbc25f6c92ab0b.jpg',
    views: 1023
  },
  {
    title: 'Low Impact',
    id: 6,
    img: 'https://i.pinimg.com/564x/9d/d5/56/9dd5563f6641631f9ccadcc59cff97ed.jpg',
    views: 56411
  }
]

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
