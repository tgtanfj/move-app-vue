<template>
  <div class="bg-white w-full h-full">
    <h2 class="text-2xl m-7 font-bold">Videos</h2>
    <div class="mt-4" v-if="videoList.length !== 0">
      <Table :list="videoList" />
      <div class="flex justify-between items-center mt-5">
        <div class="flex gap-3 items-center">
          <p class="text-sm ml-5">SHOW</p>
          <Select class="text-primary">
            <SelectTrigger class="w-[64px] text-primary border-primary">
              <SelectValue placeholder="10" />
            </SelectTrigger>
            <SelectContent ctContent class="text-primary">
              <SelectGroup>
                <SelectItem value="5">5</SelectItem>
                <SelectItem value="10">10</SelectItem>
                <SelectItem value="20">20 </SelectItem>
              </SelectGroup>
            </SelectContent>
          </Select>
        </div>
        <div>
          <Pagination>
            <PaginationList>
              <PaginationPrev @click="handlePrevPage" />
              <PaginationListItem class="gap-1" v-for="item in pageCounts" :key="item">
                <Button
                  class="mr-2"
                  :variant="item === selectedPage ? '' : 'outline'"
                  @click="selectedPage = item"
                  >{{ item }}</Button
                >
              </PaginationListItem>
              <PaginationNext @click="handleNextPage" />
            </PaginationList>
          </Pagination>
        </div>
      </div>
    </div>
    <div class="mt-4 ml-7" v-else>
      <p class="ml-5 mt-4 italic">You have not uploaded any videos yet.</p>
      <Button variant="default" class="flex items-center gap-2 mt-3">
        <FileVideo2 class="text-xl" />
        <span class="text-base font-semibold -mb-1">Upload a video</span>
      </Button>
    </div>
  </div>
</template>

<script setup>
import Button from '@common/ui/button/Button.vue'
import Table from '@components/Table.vue'
import { FileVideo2 } from 'lucide-vue-next'
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectLabel,
  SelectTrigger,
  SelectValue
} from '@common/ui/select'
import { ref, watch } from 'vue'
import {
  Pagination,
  PaginationList,
  PaginationListItem,
  PaginationNext,
  PaginationPrev
} from '@common/ui/pagination'

const videoList = ref([
  {
    id: 1,
    image:
      'https://plus.unsplash.com/premium_photo-1661780520964-29ce51eaa4b6?q=80&w=2072&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    title: 'Leg Days',
    description: 'Just Move',
    level: 'beginner',
    duration: '1 hour',
    datePosted: '13 August 20202',
    view: 1345,
    comments: 10,
    rating: 4.5
  },
  {
    id: 2,
    image:
      'https://plus.unsplash.com/premium_photo-1661780520964-29ce51eaa4b6?q=80&w=2072&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    title: 'Leg Days',
    description: 'Just Move',
    level: 'beginner',
    duration: '1 hour',
    datePosted: '24 August 2020',
    view: 1345,
    comments: 12,
    rating: 4.5
  },
  {
    id: 3,
    image:
      'https://plus.unsplash.com/premium_photo-1661780520964-29ce51eaa4b6?q=80&w=2072&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    title: 'Leg Days',
    description: 'Just Move',
    level: 'beginner',
    duration: '1 hour',
    datePosted: '13 August 2020',
    view: 1345,
    comments: 10,
    rating: 4.5
  },
  {
    id: 4,
    image:
      'https://plus.unsplash.com/premium_photo-1661780520964-29ce51eaa4b6?q=80&w=2072&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    title: 'Leg Days',
    description: 'Just Move',
    level: 'beginner',
    duration: '1 hour',
    datePosted: '13 August 2020',
    view: 1345,
    comments: 10,
    rating: 4.5
  },
  {
    id: 5,
    image:
      'https://plus.unsplash.com/premium_photo-1661780520964-29ce51eaa4b6?q=80&w=2072&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    title: 'Leg Days',
    description: 'Just Move',
    level: 'beginner',
    duration: '1 hour',
    datePosted: '13 August 2020',
    view: 1345,
    comments: 10,
    rating: 4.5
  },
  {
    id: 6,
    image:
      'https://plus.unsplash.com/premium_photo-1661780520964-29ce51eaa4b6?q=80&w=2072&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    title: 'Leg Days',
    description: 'Just Move',
    level: 'beginner',
    duration: '1 hour',
    datePosted: '13 August 2020',
    view: 1345,
    comments: 10,
    rating: 4.5
  },
  {
    id: 7,
    image:
      'https://plus.unsplash.com/premium_photo-1661780520964-29ce51eaa4b6?q=80&w=2072&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    title: 'Leg Days',
    description: 'Just Move',
    level: 'beginner',
    duration: '1 hour',
    datePosted: '13 August 2020',
    view: 1345,
    comments: 10,
    rating: 4.5
  }
])
const count = ref(null)
const pageCounts = ref([1, 2, 3])
const selectedPage = ref(1)

const handleNextPage = () => {}
const handlePrevPage = () => {}
</script>
