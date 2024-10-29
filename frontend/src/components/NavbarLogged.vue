<template>
  <div class="flex items-center gap-2 h-full">
    <!-- <p v-if="!isInStreamerPage" class="font-bold text-center text-[16px] text-nowrap">Get REP$</p> -->
    <div class="mr-2">
      <GetRep :isInStreamerPage="isInStreamerPage" />
    </div>
    <Notification />
    <BellIcon />
    <DropdownMenu>
      <DropdownMenuTrigger class="w-[30px] h-[30px]">
        <img
          :src="authStore.user.photoURL || authStore.user.avatar || userAvatar || defaultAvatar"
          alt="Avatar"
          class="w-[30px] h-[30px] object-cover rounded-full"
        />
      </DropdownMenuTrigger>

      <DropdownMenuContent align="end" class="mt-3 p-4 pt-5 w-[260px]">
        <DropdownMenuItem
          class="flex items-center gap-2 p-0 pb-2 cursor-pointer group hover:text-primary focus:bg-transparent"
        >
          <img
            :src="authStore.user.photoURL || authStore.user.avatar || userAvatar || defaultAvatar"
            alt="Avatar"
            class="w-[40px] h-[40px] rounded-full"
          />
          <p class="font-semibold text-lg group-hover:text-primary duration-100">
            {{
              authStore.usernameUser ||
              authStore.user.username ||
              authStore.user?.data?.username ||
              storedUserInfo
            }}
          </p>
        </DropdownMenuItem>
        <DropdownMenuSeparator />
        <RouterLink @click="createChannel" to="/streamer/videos">
          <DropdownMenuItem
            class="flex gap-3 items-center py-2 px-0 cursor-pointer group hover:text-primary focus:bg-transparent"
          >
            <DashboardIcon class="group-hover:text-primary duration-100" />
            <p class="font-semibold group-hover:text-primary duration-100">Dashboard</p>
          </DropdownMenuItem>
        </RouterLink>
        <DropdownMenuItem
          class="flex gap-3 items-center py-2 px-0 cursor-pointer group hover:text-primary focus:bg-transparent"
        >
          <RouterLink
            to="/wallet"
            class="w-full flex gap-3 items-center py-1 px-0 cursor-pointer group-hover:text-primary"
          >
            <WalletIcon class="group-hover:text-primary duration-100" />
            <p class="font-semibold group-hover:text-primary duration-100">Wallet (0 REPs)</p>
          </RouterLink>
        </DropdownMenuItem>
        <DropdownMenuSeparator />
        <DropdownMenuItem class="group cursor-pointer px-0 focus:bg-transparent">
          <RouterLink
            to="/profile"
            class="w-full flex gap-3 items-center py-1 px-0 cursor-pointer group-hover:text-primary"
          >
            <SettingIcon class="group-hover:text-primary duration-100" />
            <p class="font-semibold group-hover:text-primary duration-100">Settings</p>
          </RouterLink>
        </DropdownMenuItem>
        <DropdownMenuSeparator />
        <DropdownMenuItem
          @click="showLogoutModal = true"
          class="flex gap-3 px-0 items-center py-2 cursor-pointer group hover:text-primary focus:bg-transparent"
        >
          <LogoutIcon class="group-hover:text-primary duration-100" />
          <p class="font-semibold group-hover:text-primary duration-100">
            {{ $t('logout.title') }}
          </p>
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
    <BaseDialog
      :title="$t('logout.title')"
      :description="$t('logout.desc')"
      v-model:open="showLogoutModal"
    >
      <div class="flex justify-end items-center">
        <Button @click="showLogoutModal = false" variant="outline">{{
          $t('button.cancel')
        }}</Button>
        <Button @click="logOutGoogle">{{ $t('button.confirm') }}</Button>
      </div></BaseDialog
    >
  </div>
</template>

<script setup>
import DashboardIcon from '@assets/icons/DashboardIcon.vue'
import defaultAvatar from '@assets/icons/default-avatar.png'
import LogoutIcon from '@assets/icons/LogoutIcon.vue'
import SettingIcon from '@assets/icons/SettingIcon.vue'
import WalletIcon from '@assets/icons/WalletIcon.vue'
import { Button } from '@common/ui/button'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger
} from '@common/ui/dropdown-menu'
import { ref } from 'vue'
import { RouterLink, useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import BaseDialog from './BaseDialog.vue'
import { videoService } from '@services/video.services'
import Notification from '@components/notificataion/Notification.vue'
import GetRep from './rep/GetRep.vue'

const props = defineProps({
  isInStreamerPage: {
    type: Boolean,
    required: false
  }
})

const authStore = useAuthStore()
const router = useRouter()
const showLogoutModal = ref(false)
const userAvatar = ref(localStorage.getItem('userAvatar'))
const storedUserInfo = localStorage.getItem('userInfo')

const logOutGoogle = async () => {
  await authStore.logout()
  showLogoutModal.value = false
  router.push('/')
}

const createChannel = async () => {
  await videoService.createChannel()
}
</script>
