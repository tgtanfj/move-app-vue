<script setup>
import { Button } from '@common/ui/button'
import { useAuthStore } from '../../stores/auth'
import { useOpenLoginStore } from '../../stores/openLogin'
import { ArrowRightFromLine } from 'lucide-vue-next'
import { ArrowLeft } from 'lucide-vue-next'
import { onMounted, ref } from 'vue'
import BlueBadgeIcon from '@assets/icons/BlueBadgeIcon.vue'
import FollowedChannelsSkeleton from './FollowedChannelsSkeleton.vue'
import { getFollowerText } from '@utils/follower.util'
import { useRouter } from 'vue-router'
import { useFollowerStore } from '../../stores/follower.store'
import { formatFollowers } from '@utils/formatViews.util'

const props = defineProps({
  sidebarOpen: {
    type: Boolean,
    required: true
  }
})

const emit = defineEmits(['toggleSidebar'])

const router = useRouter()
const openLoginStore = useOpenLoginStore()
const authStore = useAuthStore()
const followerStore = useFollowerStore()

const isLoading = ref(false)

onMounted(async () => {
  const accessToken = localStorage.getItem('token')
  if (accessToken) {
    isLoading.value = true
    await followerStore.getAllFollowers()
    isLoading.value = false
  }
})

const toggleSidebar = () => {
  emit('toggleSidebar')
}

const handleClick = () => {
  openLoginStore.toggleOpenLogin()
  openLoginStore.handleClickSignUpFromSidebar()
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

      <div class="flex flex-col w-full mt-4 gap-4">
        <div
          v-if="authStore.accessToken"
          v-for="channel in followerStore.follower"
          :key="channel.id"
          class="flex items-center w-full gap-1 cursor-pointer"
          @click="router.push(`/channel/${channel.id}`)"
        >
          <img
            :src="channel.image"
            alt="Avatar"
            class="w-10 h-10 rounded-full object-cover shrink-0"
          />
          <div class="flex flex-col gap-0 w-full">
            <div class="flex gap-2">
              <span
                v-if="sidebarOpen"
                class="ml-2 text-sm overflow-hidden max-w-[145px] text-ellipsis whitespace-nowrap"
              >
                {{ channel.name }}
              </span>
              <BlueBadgeIcon v-if="channel.isBlueBadge && sidebarOpen" />
            </div>
            <div v-show="sidebarOpen" class="ml-2">
              <span class="text-sm text-[#666666]">
                {{ formatFollowers(channel.numberOfFollowers) }}
                {{ getFollowerText(channel.numberOfFollowers) }}
              </span>
            </div>
          </div>
        </div>
        <div v-if="isLoading" v-for="item in 10">
          <FollowedChannelsSkeleton />
        </div>
        <p
          v-if="sidebarOpen && authStore.accessToken && followerStore.follower.length === 0 && !isLoading"
          class="text-[16px] text-[#666666]"
        >
          {{ $t('sidebar.not_login') }}
        </p>
        <div
          v-if="sidebarOpen && !authStore.accessToken && !isLoading"
          :class="sidebarOpen ? 'opacity-100 delay-500' : 'opacity-0'"
          class="w-full h-[220px] bg-primary rounded-lg shadow-lg flex flex-col p-4 items-start justify-between transition-opacity opacity-0 duration-500 ease-in-out"
        >
          <div class="flex flex-col item-center gap-4">
            <p class="font-bold text-[24px] text-white leading-8">{{ $t('sidebar.interested') }}</p>
            <p class="text-secondary text-[16px]">
              {{ $t('sidebar.sign_up_title') }}
            </p>
          </div>
          <Button @click="handleClick" variant="outline">{{ $t('sidebar.sign_up') }}</Button>
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
