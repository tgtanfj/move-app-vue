<script setup>
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@common/ui/select'
import { ref } from 'vue'
import CustomSelection from './CustomSelection.vue'

const levelItems = ref([
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

const sortByItems = ref([
  {
    title: 'All time',
    value: 'all'
  },
  {
    title: 'Most recent',
    value: 'recent'
  },
  {
    title: 'Last 7 days',
    value: '7days'
  },
  {
    title: 'Last 30 days',
    value: '30days'
  },
  {
    title: 'Last 90 days',
    value: '90days'
  },
  {
    title: '1 year ago',
    value: '1year'
  },
  {
    title: 'More than 1 year ago',
    value: '1yearago'
  }
])
</script>
<template>
  <CustomSelection label="level" :listItems="levelItems" />
  <CustomSelection label="category" :listItems="categoryItems" />
  <CustomSelection label="sort by" :listItems="sortByItems" />
</template>
