<script setup>
import { Button } from '@common/ui/button'
import { ArrowRightFromLine } from 'lucide-vue-next'
import { ArrowLeft } from 'lucide-vue-next'
import { ref } from 'vue'

const props = defineProps({
  sidebarOpen: {
    type: Boolean,
    required: true
  }
})

const emit = defineEmits(['toggleSidebar'])

const channels = [
  {
    id: 1,
    name: 'The Rock',
    avatar:
      'https://vcdn1-giaitri.vnecdn.net/2020/10/18/main-qimg-0382435c04d3012b3370-2771-8312-1602985058.jpg?w=460&h=0&q=100&dpr=2&fit=crop&s=Rk2kSfST--gVjysQOZTyaw'
  },
  {
    id: 2,
    name: 'Larry Wheels',
    avatar:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4J3EBuyb_XhtUkG8nGP4X5tqFslH8b5IfVg&s'
  }
]

const toggleSidebar = () => {
  emit('toggleSidebar')
}
</script>

<template>
  <div class="flex pt-[56px]">
    <div
      :class="[
        'fixed top-15 left-0 bg-white text-black p-4 h-screen transition-all border-r-2 border-[#e2e2e2]',
        sidebarOpen ? 'w-[240px]' : 'w-[65px]'
      ]"
    >
      <div class="flex justify-between items-center">
        <p v-if="sidebarOpen" class="font-bold text-[12px] uppercase text-nowrap">
          {{ $t('sidebar.followed_channels') }}
        </p>
        <button @click="toggleSidebar" class="text-black cursor-pointer p-2">
          <ArrowLeft class="w-[24px] h-[24px]" v-show="sidebarOpen" />
          <ArrowRightFromLine class="w-[24px] h-[24px]" v-show="!sidebarOpen" />
        </button>
      </div>

      <div class="flex flex-col mt-4 gap-4">
        <div v-for="channel in channels" :key="channel.id" class="flex items-center gap-1">
          <img :src="channel.avatar" alt="Avatar" class="w-10 h-10 rounded-full object-cover" />
          <span v-if="sidebarOpen" class="ml-4 text-sm text-nowrap">{{ channel.name }}</span>
        </div>
        <p v-if="sidebarOpen" class="text-[16px] text-[#666666]">
          {{ $t('sidebar.not_login') }}
        </p>
        <div
          v-if="sidebarOpen"
          :class="sidebarOpen ? 'opacity-100 delay-500' : 'opacity-0'"
          class="w-full h-[220px] bg-primary rounded-lg shadow-lg flex flex-col p-4 items-start justify-between transition-opacity opacity-0 duration-500 ease-in-out"
        >
          <div class="flex flex-col item-center gap-4">
            <p class="font-bold text-[24px] text-white leading-8">{{ $t('sidebar.interested') }}</p>
            <p class="text-secondary text-[16px]">
              {{ $t('sidebar.sign_up_title') }}
            </p>
          </div>
          <Button variant="outline">{{ $t('sidebar.sign_up') }}</Button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.flex-1 {
  transition: margin-left 0.3s;
}
</style>
