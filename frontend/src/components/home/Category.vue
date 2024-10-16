<script setup>
import { useRouter } from 'vue-router'
import Categories from './Categories.vue'
import CategorySkeleton from './CategorySkeleton.vue'
import { onMounted } from 'vue'
import { homepageService } from '@services/homepage.services';

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

const router = useRouter()

// onMounted(async () => {
//   const response = await homepageService.getTopCategories()
//   if(response.message === 'success') {
//     console.log("res", response.data)
//   }
// })
</script>

<template>
  <div class="w-full mt-6 flex flex-col">
    <div class="flex items-center justify-between">
      <p class="font-bold text-[24px]">{{ $t('homepage.categories') }}</p>
      <p @click="router.push('/categories')" class="text-[14px] text-primary cursor-pointer">
        {{ $t('homepage.view_all') }}
      </p>
    </div>
    <div class="grid grid-cols-6 gap-3 mt-4">
      <!-- <div
        v-if="categories"
        v-for="(item, index) in categories"
        class="flex flex-col cursor-pointer"
      >
        <Categories :category="item" :key="index" />
      </div> -->
      <div v-if="categories" v-for="item in 6" :key="item" class="flex flex-col cursor-pointer">
        <CategorySkeleton />
      </div>
    </div>
  </div>
</template>
