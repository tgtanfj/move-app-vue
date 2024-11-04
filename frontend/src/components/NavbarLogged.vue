<template>
  <div class="flex items-center gap-3 h-full">
    <div class="mr-2">
      <GetRep :isInStreamerPage="isInStreamerPage" />
    </div>
    <Notification />
    <DropdownMenu>
      <DropdownMenuTrigger class="w-[30px] h-[30px]">
        <img :src="avatar" alt="Avatar" class="w-[30px] h-[30px] object-cover rounded-full" />
      </DropdownMenuTrigger>

      <DropdownMenuContent align="end" class="mt-3 p-4 pt-5 w-[260px]">
        <DropdownMenuItem
          class="flex items-center gap-1 p-0 pb-2 cursor-pointer group hover:text-primary focus:bg-transparent"
        >
          <div class="w-[40px] h-[40px] rounded-full">
            <img :src="avatar" alt="Avatar" class="w-full h-full rounded-full object-cover" />
          </div>
          <p
            class="ml-2 font-semibold text-lg group-hover:text-primary duration-100 truncate w-[150px]"
          >
            <router-link :to="`/channel/${authStore?.user?.channelId}`">
              {{
                authStore.usernameUser ||
                authStore.user.username ||
                authStore.user?.data?.username ||
                storedUserInfo
              }}
            </router-link>
          </p>
          <BlueBadgeIcon v-if="authStore.user.isBlueBadge" />
        </DropdownMenuItem>
        <DropdownMenuSeparator />

        <RouterLink
          v-if="isStreamer"
          to="/"
          @click="createChannel"
          class="w-full flex gap-3 items-center py-1 px-0 cursor-pointer group-hover:text-primary"
        >
          <DropdownMenuItem
            class="flex gap-3 items-center py-2 px-0 cursor-pointer group hover:text-primary focus:bg-transparent"
          >
            <LogoMoveMini class="group-hover:text-primary duration-100" />
            <p class="font-semibold group-hover:text-primary duration-100">Back to Move</p>
          </DropdownMenuItem>
        </RouterLink>

        <RouterLink
          v-else
          to="/streamer/videos"
          @click="createChannel"
          class="w-full flex gap-3 items-center py-1 px-0 cursor-pointer group-hover:text-primary"
        >
          <DropdownMenuItem
            class="flex gap-3 items-center py-2 px-0 cursor-pointer group hover:text-primary focus:bg-transparent"
          >
            <DashboardIcon class="group-hover:text-primary duration-100" />
            <p class="font-semibold group-hover:text-primary duration-100">Dashboard</p>
          </DropdownMenuItem>
        </RouterLink>

        <RouterLink
          v-if="isStreamer"
          to="/streamer/cashout"
          class="w-full flex gap-3 items-center py-1 px-0 cursor-pointer group-hover:text-primary"
        >
          <DropdownMenuItem
            class="flex gap-3 items-center py-2 px-0 cursor-pointer group hover:text-primary focus:bg-transparent"
          >
            <WalletIcon class="group-hover:text-primary duration-100" />
            <p class="font-semibold group-hover:text-primary duration-100">Cashout</p>
          </DropdownMenuItem>
        </RouterLink>

        <RouterLink
          v-else
          to="/streamer/cashout"
          class="w-full flex gap-3 items-center py-1 px-0 cursor-pointer group-hover:text-primary"
        >
          <DropdownMenuItem
            class="flex gap-3 items-center py-2 px-0 cursor-pointer group hover:text-primary focus:bg-transparent"
          >
            <WalletIcon class="group-hover:text-primary duration-100" />
            <p class="font-semibold group-hover:text-primary duration-100">
              Wallet ({{ paymentStore.reps }} REPs)
            </p>
          </DropdownMenuItem>
        </RouterLink>

        <DropdownMenuSeparator />
        <RouterLink
          to="/profile"
          class="w-full flex gap-3 items-center py-1 px-0 cursor-pointer group-hover:text-primary"
        >
          <DropdownMenuItem
            class="flex gap-3 items-center py-2 px-0 cursor-pointer group hover:text-primary focus:bg-transparent"
          >
            <SettingIcon class="group-hover:text-primary duration-100" />
            <p class="font-semibold group-hover:text-primary duration-100">Settings</p>
          </DropdownMenuItem>
        </RouterLink>

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
import { computed, ref, watch } from 'vue'
import { RouterLink, useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import BaseDialog from './BaseDialog.vue'
import { videoService } from '@services/video.services'
import Notification from '@components/notificataion/Notification.vue'
import GetRep from './rep/GetRep.vue'
import { usePaymentStore } from '../stores/payment'
import BlueBadgeIcon from '@assets/icons/BlueBadgeIcon.vue'

const props = defineProps({
  isInStreamerPage: {
    type: Boolean,
    required: false
  }
})

const authStore = useAuthStore()
const paymentStore = usePaymentStore()
const router = useRouter()
const showLogoutModal = ref(false)
const storedUserInfo = localStorage.getItem('userInfo')
const fetchLocalAvatar = () => {
  return localStorage.getItem('userAvatar') || defaultAvatar
}

const avatar = computed(() => {
  return authStore.user?.avatar || fetchLocalAvatar()
})

const logOutGoogle = async () => {
  await authStore.logout()
  showLogoutModal.value = false
  router.push('/')
}

const createChannel = async () => {
  await videoService.createChannel()
}
</script>
