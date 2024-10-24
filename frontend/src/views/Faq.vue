<script setup>
import FaqItem from '@components/faq/FaqItem.vue'
import Loading from '@components/Loading.vue'
import { ADMIN_BASE } from '@constants/api.constant'
import axios from 'axios'
import { onMounted, ref } from 'vue'

const isLoading = ref(false)
const err = ref('')
const list = ref([])

onMounted(async () => {
  try {
    isLoading.value = true
    const response = await axios.get(`${ADMIN_BASE}/faqs`)
    if (response.status === 200) {
      list.value = [...response.data.data]
    } else throw new Error(response.error)
  } catch (error) {
    err.value = error.message
  } finally {
    isLoading.value = false
  }
})
</script>

<template>
  <div class="w-full h-full pt-[56px] pr-[200px]">
    <Loading v-if="isLoading" class="mt-48"/>
    <p v-else-if="err" class="text-red-500 text-xl mt-6">
      {{ err }}
    </p>
    <div class="mt-6" v-else>
      <h1 class="text-3xl font-bold my-4">FAQ</h1>
      <div v-for="item in list" :key="item.id">
        <FaqItem :item="item" />
      </div>
    </div>
  </div>
</template>
