<template>
  <div class="flex items-center gap-6 h-full">
    <p class="font-bold text-center text-[16px] text-nowrap">Get REP$</p>
    <BellIcon />
    <DropdownMenu>
      <DropdownMenuTrigger>
        <img
          :src="authStore.user?.photoURL"
          alt="Avatar"
          width="30"
          height="30"
          class="rounded-full"
        />
      </DropdownMenuTrigger>

      <DropdownMenuContent align="end" class="mt-3 p-4 pt-5 w-[260px]">
        <RouterLink to="/profile">
          <DropdownMenuItem
            class="flex items-center gap-2 p-0 pb-2 cursor-pointer group hover:text-primary focus:bg-transparent"
          >
            <img
              :src="authStore.user?.photoURL"
              alt="Avatar"
              width="40"
              height="40"
              class="rounded-full"
            />
            <p class="font-semibold text-lg group-hover:text-primary duration-100">
              {{ authStore.user?.displayName || authStore.user?.name }}
            </p>
          </DropdownMenuItem>
        </RouterLink>
        <DropdownMenuSeparator />
        <DropdownMenuItem
          class="flex gap-3 items-center py-2 px-0 cursor-pointer group hover:text-primary focus:bg-transparent"
        >
          <DashboardIcon class="group-hover:text-primary duration-100" />
          <p class="font-semibold group-hover:text-primary duration-100">Dashboard</p>
        </DropdownMenuItem>
        <DropdownMenuItem
          class="flex gap-3 items-center py-2 px-0 cursor-pointer group hover:text-primary focus:bg-transparent"
        >
          <WalletIcon class="group-hover:text-primary duration-100" />
          <p class="font-semibold group-hover:text-primary duration-100">
            Wallet (<span class="font-semibold">0</span> REPs)
          </p>
        </DropdownMenuItem>
        <DropdownMenuSeparator />
        <DropdownMenuItem
          class="flex gap-3 items-center py-2 px-0 cursor-pointer group hover:text-primary focus:bg-transparent"
        >
          <SettingIcon class="group-hover:text-primary duration-100" />
          <p class="font-semibold group-hover:text-primary duration-100">Settings</p>
        </DropdownMenuItem>
        <DropdownMenuSeparator />
        <DropdownMenuItem
          @click="logOutGoogle"
          class="flex gap-3 px-0 items-center py-2 cursor-pointer group hover:text-primary focus:bg-transparent"
        >
          <LogoutIcon class="group-hover:text-primary duration-100" />
          <p class="font-semibold group-hover:text-primary duration-100">Log Out</p>
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  </div>
</template>

<script setup>
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger
} from '@common/ui/dropdown-menu'
import { useAuthStore } from '../stores/auth'
import { RouterLink, useRouter } from 'vue-router'
import LogoutIcon from '@assets/icons/LogoutIcon.vue'
import SettingIcon from '@assets/icons/SettingIcon.vue'
import WalletIcon from '@assets/icons/WalletIcon.vue'
import DashboardIcon from '@assets/icons/DashboardIcon.vue'
import BellIcon from '@assets/icons/BellIcon.vue'

const authStore = useAuthStore()
const router = useRouter()

const logOutGoogle = async () => {
  await authStore.logout()
  router.push('/')
}
</script>
