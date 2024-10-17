<script setup>
import { useRouter } from 'vue-router'
import Categories from './Categories.vue'
import CategorySkeleton from './CategorySkeleton.vue'
import { onMounted, ref } from 'vue'
import { homepageService } from '@services/homepage.services';


const router = useRouter()
const categories = ref(null)

onMounted(async () => {
  const response = await homepageService.getTopCategories()
  if(response.message === 'success') {
    categories.value = response?.data
  }
})

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
      <div
        v-if="categories"
        v-for="(item, index) in categories"
        class="flex flex-col cursor-pointer"
      >
        <Categories :category="item" :key="index" />
      </div>
      <div v-if="!categories" v-for="item in 6" :key="item" class="flex flex-col cursor-pointer">
        <CategorySkeleton />
      </div>
    </div>
  </div>
</template>
