<script setup>
import DashboardIcon from '@assets/icons/DashboardIcon.vue'
import LogoMoveMini from '@assets/icons/LogoMoveMini.vue'
import defaultAvatar from '@assets/images/default-avatar.png'
import LogoutIcon from '@assets/icons/LogoutIcon.vue'
import SettingIcon from '@assets/icons/SettingIcon.vue'
import WalletIcon from '@assets/icons/WalletIcon.vue'
import BlueBadgeIcon from '@assets/icons/BlueBadgeIcon.vue'
import { Button } from '@common/ui/button'
import { Popover, PopoverContent, PopoverTrigger } from '@common/ui/popover'
import BaseDialog from './BaseDialog.vue'

import { ref, watch } from 'vue'
import { RouterLink, useRoute, useRouter } from 'vue-router'

import { useAuthStore } from '../stores/auth'
import { usePaymentStore } from '../stores/payment'
import { videoService } from '@services/video.services'
import { useSearchStore } from '../stores/search'

const props = defineProps({
  isInStreamerPage: {
    type: Boolean,
    required: false
  }
})

const authStore = useAuthStore()
const paymentStore = usePaymentStore()
const searchStore = useSearchStore()
const router = useRouter()
const route = useRoute()
const isStreamer = ref(route.path.startsWith('/streamer'))

const showMenuAccount = ref(false)
const showLogoutModal = ref(false)

const userAvatar = localStorage.getItem('userAvatar')
const storedUserInfo = localStorage.getItem('userInfo')
const isBlueBadge = localStorage.getItem('userIsBlueBadge')
const channelId = localStorage.getItem('userChannelId')

const logOutGoogle = async () => {
  await authStore.logout()
  searchStore.text = ''
  showLogoutModal.value = false
  showMenuAccount.value = false
  router.push('/')
}

const createChannel = async () => {
  showMenuAccount.value = false
  if (!route.path.startsWith('/streamer')) {
    await videoService.createChannel()
  }
}

const handleOpenPopover = () => {
  showMenuAccount.value = true
}

const closeMenuAccount = () => {
  showMenuAccount.value = false
}

const handleImageError = (event) => {
  event.target.src = defaultAvatar
}

watch(
  () => route.path,
  (newPath) => {
    isStreamer.value = newPath.startsWith('/streamer')
  }
)
</script>

<template>
  <Popover v-model:open="showMenuAccount">
    <PopoverTrigger @click="handleOpenPopover" class="w-[30px] h-[30px]">
      <img
        :src="authStore.user.photoURL || authStore.user.avatar || userAvatar || defaultAvatar"
        alt="Avatar"
        class="w-[30px] h-[30px] object-cover rounded-full"
        @error="handleImageError"
      />
    </PopoverTrigger>

    <PopoverContent align="end" class="mt-3 p-4 pt-5 w-[260px]">
      <RouterLink
        :to="`/channel/${authStore.user.channelId || authStore.channelId || channelId}`"
        @click="closeMenuAccount"
      >
        <div
          class="flex items-center gap-1 p-0 pb-2 cursor-pointer group hover:text-primary focus:bg-transparent"
        >
          <div class="w-[40px] h-[40px] rounded-full">
            <img
              :src="authStore.user.photoURL || authStore.user.avatar || userAvatar || defaultAvatar"
              alt="Avatar"
              class="w-full h-full rounded-full object-cover"
              @error="handleImageError"
            />
          </div>
          <p
            class="ml-2 font-semibold text-lg group-hover:text-primary duration-100 truncate w-auto max-w-[150px]"
          >
            {{
              authStore.usernameUser ||
              authStore.user.username ||
              authStore.user?.data?.username ||
              storedUserInfo
            }}
          </p>
          <BlueBadgeIcon
            v-if="authStore.user.isBlueBadge || authStore.blueBadge || isBlueBadge === 'true'"
          />
        </div>
      </RouterLink>

      <hr />

      <RouterLink
        v-if="isStreamer"
        to="/"
        @click="createChannel"
        class="w-full flex gap-3 items-center py-1 px-0 cursor-pointer group hover:text-primary focus:bg-transparent"
      >
        <div
          class="flex gap-3 items-center py-2 px-0 cursor-pointer group-hover:text-primary"
        >
          <LogoMoveMini class="group-hover:text-primary duration-100" />
          <p class="font-semibold group-hover:text-primary duration-100">Back to Move</p>
        </div>
      </RouterLink>

      <RouterLink
        v-else
        to="/streamer/videos"
        @click="createChannel"
        class="w-full flex gap-3 items-center py-1 px-0 cursor-pointer group hover:text-primary focus:bg-transparent"
      >
        <div
          class="flex gap-3 items-center py-2 px-0 cursor-pointer group-hover:text-primary"
        >
          <DashboardIcon class="group-hover:text-primary duration-100" />
          <p class="font-semibold group-hover:text-primary duration-100">Dashboard</p>
        </div>
      </RouterLink>

      <RouterLink
        v-if="isStreamer"
        to="/streamer/cashout"
        @click="closeMenuAccount"
        class="w-full flex gap-3 items-center py-1 px-0 cursor-pointer group hover:text-primary focus:bg-transparent"
      >
        <div
          class="flex gap-3 items-center py-2 px-0 cursor-pointer group-hover:text-primary"
        >
          <WalletIcon class="group-hover:text-primary duration-100" />
          <p class="font-semibold group-hover:text-primary duration-100">Cashout</p>
        </div>
      </RouterLink>

      <RouterLink
        v-else
        to="/wallet"
        @click="closeMenuAccount"
        class="w-full flex gap-3 items-center py-1 px-0 cursor-pointer group hover:text-primary focus:bg-transparent"
      >
        <div
          class="flex gap-3 items-center py-2 px-0 cursor-pointer group-hover:text-primary"
        >
          <WalletIcon class="group-hover:text-primary duration-100" />
          <p class="font-semibold group-hover:text-primary duration-100">
            Wallet ({{ paymentStore.reps }} REPs)
          </p>
        </div>
      </RouterLink>

      <hr />

      <RouterLink
        to="/profile"
        @click="closeMenuAccount"
        class="w-full flex gap-3 items-center py-1 px-0 cursor-pointer group hover:text-primary focus:bg-transparent"
      >
        <div
          class="flex gap-3 items-center py-2 px-0 cursor-pointer group-hover:text-primary"
        >
          <SettingIcon class="group-hover:text-primary duration-100" />
          <p class="font-semibold group-hover:text-primary duration-100">Settings</p>
        </div>
      </RouterLink>

      <hr />

      <div
        @click="showLogoutModal = true"
        class="flex gap-3 px-0 items-center pt-4 pb-2 cursor-pointer group hover:text-primary focus:bg-transparent"
      >
        <LogoutIcon class="group-hover:text-primary duration-100" />
        <p class="font-semibold group-hover:text-primary duration-100">
          {{ $t('logout.title') }}
        </p>
      </div>
    </PopoverContent>
  </Popover>

  <BaseDialog
    :title="$t('logout.title')"
    :description="$t('logout.desc')"
    v-model:open="showLogoutModal"
  >
    <div class="flex justify-end items-center">
      <Button @click="showLogoutModal = false" variant="outline">{{ $t('button.cancel') }}</Button>
      <Button @click="logOutGoogle">{{ $t('button.confirm') }}</Button>
    </div></BaseDialog
  >
</template>
