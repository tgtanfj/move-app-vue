<script setup>
import { Button } from '@common/ui/button'
import { useAuthStore } from '../../stores/auth'
import { ArrowRightFromLine } from 'lucide-vue-next'
import { ArrowLeft } from 'lucide-vue-next'
import { computed, ref } from 'vue'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger
} from '@common/ui/dialog'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@common/ui/tabs'
import SignInModal from '@components/auth/SignInModal.vue'
import SignUpModal from '@components/auth/SignUpModal.vue'
import LogoBlack from '@assets/icons/LogoBlack.vue'
import ForgotPassword from '@components/auth/ForgotPassword.vue'
import OTPVerificationModal from '@components/auth/OTPVerificationModal.vue'

const props = defineProps({
  sidebarOpen: {
    type: Boolean,
    required: true
  }
})

const emit = defineEmits(['toggleSidebar'])

const isOpen = ref(false)
const openForgotPassword = ref(false)
const openOTPModal = ref(false)
const signupInfo = ref('')
let timer = null
const countdown = ref(60)
const isCounting = ref(false)

const authStore = useAuthStore()

const isUserLoggedIn = computed(() => !!authStore.accessToken)

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

const closeModal = () => {
  isOpen.value = false
}

const onOpenForgotPassword = () => {
  openForgotPassword.value = true
  closeModal()
}

const startCountdown = () => {
  isCounting.value = true
  timer = setInterval(() => {
    if (countdown.value > 0) {
      countdown.value--
    } else {
      clearInterval(timer)
      isCounting.value = false
    }
  }, 1000)
}

const handleOpenOTPVerification = (values) => {
  openOTPModal.value = true
  signupInfo.value = values

  countdown.value = 60
  clearInterval(timer)
  startCountdown()
}

const openLoginModal = () => {
  isOpen.value = true
  openForgotPassword.value = false
}

const handleVerifySuccess = async (values) => {
  openOTPModal.value = false
  clearInterval(timer)
  isCounting.value = false
  await authStore.loginWithEmail(values)
}

const resetCountdown = () => {
  countdown.value = 60
  startCountdown()
}

const onDialogClose = () => {
  isOpen.value = false
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
        <div
          v-if="Object.keys(authStore.user).length !== 0"
          v-for="channel in channels"
          :key="channel.id"
          class="flex items-center gap-1"
        >
          <img :src="channel.avatar" alt="Avatar" class="w-10 h-10 rounded-full object-cover" />
          <span v-if="sidebarOpen" class="ml-4 text-sm text-nowrap">{{ channel.name }}</span>
        </div>
        <p
          v-if="sidebarOpen && Object.keys(authStore.user).length !== 0"
          class="text-[16px] text-[#666666]"
        >
          {{ $t('sidebar.not_login') }}
        </p>
        <div
          v-if="sidebarOpen && Object.keys(authStore.user).length === 0"
          :class="sidebarOpen ? 'opacity-100 delay-500' : 'opacity-0'"
          class="w-full h-[220px] bg-primary rounded-lg shadow-lg flex flex-col p-4 items-start justify-between transition-opacity opacity-0 duration-500 ease-in-out"
        >
          <div class="flex flex-col item-center gap-4">
            <p class="font-bold text-[24px] text-white leading-8">{{ $t('sidebar.interested') }}</p>
            <p class="text-secondary text-[16px]">
              {{ $t('sidebar.sign_up_title') }}
            </p>
          </div>
          <Button @click="isOpen = true" variant="outline">{{ $t('sidebar.sign_up') }}</Button>
        </div>
      </div>
    </div>
  </div>

  <Dialog v-model:open="isOpen" @update:open="onDialogClose">
    <DialogContent>
      <DialogHeader>
        <DialogTitle class="w-24 m-auto">
          <LogoBlack />
        </DialogTitle>
      </DialogHeader>
      <DialogDescription></DialogDescription>
      <Tabs default-value="login" class="w-full">
        <TabsList
          class="w-full m-auto border-b-[1px] border-[#999999] pb-0 rounded-none mb-3 bg-white"
        >
          <TabsTrigger
            value="login"
            class="data-[state=active]:border-b-[3px] border-b-[3px] px-0 mx-3 border-white rounded-none data-[state=active]:border-[#13D0B4] data-[state=active]:text-[#13D0B4]"
          >
            <span class="font-bold">Log In</span>
          </TabsTrigger>
          <TabsTrigger
            value="signup"
            class="data-[state=active]:border-b-[3px] border-b-[3px] px-0 mx-3 border-white rounded-none data-[state=active]:border-[#13D0B4] data-[state=active]:text-[#13D0B4]"
          >
            <span class="font-bold">Sign up</span>
          </TabsTrigger>
        </TabsList>
        <TabsContent value="login">
          <SignInModal :closeModal="closeModal" @openForgotPassword="onOpenForgotPassword" />
        </TabsContent>
        <TabsContent value="signup">
          <SignUpModal
            :closeModal="closeModal"
            @open-otp-verification="handleOpenOTPVerification"
          />
        </TabsContent>
      </Tabs>
    </DialogContent>
  </Dialog>

  <ForgotPassword
      v-if="!isUserLoggedIn"
      v-model:open="openForgotPassword"
      @open-login="openLoginModal"
    />
    <OTPVerificationModal
      v-if="!isUserLoggedIn"
      v-model:open="openOTPModal"
      :signupInfo="signupInfo"
      :countdown="countdown"
      :isCounting="isCounting"
      @verify-success="handleVerifySuccess"
      @start="startCountdown"
      @reset="resetCountdown"
    />
</template>

<style scoped>
.flex-1 {
  transition: margin-left 0.3s;
}
</style>
