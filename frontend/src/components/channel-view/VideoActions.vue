<script setup>
import { ref } from 'vue'
import { LEVEL, SORT_BY } from '../../constants/view-channel.constant'
import CustomSelection from './CustomSelection.vue'
const categoryItems = ref([
  {
    title: 'All levels',
    value: 'all'
  },
  {
    title: 'Intermediate',
    value: 'intermediate'
  },
  {
    title: 'Advanced',
    value: 'advanced'
  }
])
</script>
<template>
  <CustomSelection label="level" :listItems="LEVEL" />
  <CustomSelection label="category" :listItems="categoryItems" />
  <CustomSelection label="sort by" :listItems="SORT_BY" />
</template>
