<script setup>
import { formatCategoryTitleToUrl } from '@utils/formatCategoryTitle.util'
import { formatViews } from '@utils/formatViews.util'
import { useRouter } from 'vue-router'

const props = defineProps({
  category: {
    type: Object,
    required: true
  },
  imageHeight: {
    type: Number,
    required: false
  }
})

const router = useRouter()

const categoryTitle = formatCategoryTitleToUrl(props.category.title)
</script>

<template>
  <div @click="router.push(`/categories/${categoryTitle}/${category?.id}`)">
    <div>
      <img
        :src="category?.image"
        :alt="category?.title"
        class="h-[220px] w-full object-cover aspect-w-1 aspect-h-1"
      />
    </div>
    <p class="text-[18px] mt-3 font-bold">{{ category?.title }}</p>
    <p class="text-[14px] text-[#666666]">
      {{ category?.numberOfViews ? formatViews(category?.numberOfViews) : '0' }}
      views
    </p>
  </div>
</template>
