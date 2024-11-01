<script setup>
import LogoBlack from '@assets/icons/LogoBlack.vue'
import LogoWhite from '@assets/icons/LogoWhite.vue'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger
} from '@common/ui/dialog'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@common/ui/tabs'
import NavbarLogged from '@components/NavbarLogged.vue'
import ForgotPassword from '@components/auth/ForgotPassword.vue'
import OTPVerificationModal from '@components/auth/OTPVerificationModal.vue'
import SignInModal from '@components/auth/SignInModal.vue'
import SignUpModal from '@components/auth/SignUpModal.vue'
import { computed, ref, watch, watchEffect } from 'vue'
import { useRoute } from 'vue-router'
import Button from '../common/ui/button/Button.vue'
import { useAuthStore } from '../stores/auth'
import { useOpenLoginStore } from '../stores/openLogin'
import UploadVideo from './upload-video/UploadVideo.vue'
import Search from './search/Search.vue'
import { useFollowerStore } from '../stores/follower.store'

const countdown = ref(60)
const isCounting = ref(false)
let timer = null
const isOpen = ref(false)
const openForgotPassword = ref(false)
const openOTPModal = ref(false)
const signupInfo = ref('')
const isInStreamerPage = ref(false)
const isInResetPWPage = ref(false)
const authStore = useAuthStore()
const openLoginStore = useOpenLoginStore()
const followerStore = useFollowerStore()
const route = useRoute()

watch(
  () => route.path,
  (newValue) => {
    if (newValue && newValue.includes('/streamer')) {
      isInStreamerPage.value = true
    } else isInStreamerPage.value = false
    if (newValue && newValue.includes('/reset-password')) {
      isInResetPWPage.value = true
    } else isInResetPWPage.value = false
  },
  { immediate: true }
)

const isUserLoggedIn = computed(() => !!authStore.accessToken)

const closeModal = () => {
  isOpen.value = false
}

const onOpenForgotPassword = () => {
  openForgotPassword.value = true
  closeModal()
}

const openLoginModal = () => {
  isOpen.value = true
  openForgotPassword.value = false
}

const handleOpenOTPVerification = (values) => {
  openOTPModal.value = true
  signupInfo.value = values

  countdown.value = 60
  clearInterval(timer)
  startCountdown()
}

const handleVerifySuccess = async (values) => {
  openOTPModal.value = false
  clearInterval(timer)
  isCounting.value = false
  await authStore.loginWithEmail(values)
  followerStore.getAllFollowers()
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

const resetCountdown = () => {
  countdown.value = 60
  startCountdown()
}

const onDialogClose = () => {
  openLoginStore.handleLeaveSignUpFromSidebar()
}

watchEffect(() => {
  if (openLoginStore.isOpenLogin) {
    isOpen.value = true
    openLoginStore.toggleOpenLogin()
  }
})
</script>

<template>
  <nav class="w-full bg-black text-white fixed z-50">
    <div
      class="flex items-center px-[40px] py-3"
      :class="{ 'justify-center': isInResetPWPage, 'justify-between': !isInResetPWPage }"
    >
      <ul v-if="!isInResetPWPage" class="flex flex-1 items-center gap-[35px]">
        <RouterLink to="/move/faq">
          <li class="font-semibold text-[16px]">FAQ</li>
        </RouterLink>
      </ul>

      <div class="w-[20%]">
        <div class="m-auto w-28">
          <RouterLink to="/">
            <LogoWhite />
          </RouterLink>
        </div>
      </div>

      <div v-if="!isInResetPWPage" class="flex flex-1 items-center gap-2">
        <div v-if="!isInStreamerPage" class="flex flex-1 justify-end">
          <Search />
        </div>

        <div :class="{ 'ml-auto': isInStreamerPage }">
          <Dialog v-model:open="isOpen" v-if="!isUserLoggedIn" @update:open="onDialogClose">
            <DialogTrigger>
              <Button v-if="authStore.isLoading" variant="default" class="rounded-lg" disabled>
                Loading...
              </Button>
              <Button v-else-if="!isUserLoggedIn" variant="default" class="rounded-lg">
                Log In
              </Button>
            </DialogTrigger>

            <DialogContent>
              <DialogHeader>
                <DialogTitle class="w-24 m-auto">
                  <LogoBlack />
                </DialogTitle>
              </DialogHeader>
              <DialogDescription></DialogDescription>
              <Tabs :default-value="openLoginStore.isSignUpFromSidebar ? 'signup' : 'login'" class="w-full">
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
                  <SignInModal
                    :closeModal="closeModal"
                    @openForgotPassword="onOpenForgotPassword"
                  />
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
        </div>
        <div v-if="isInStreamerPage && authStore.accessToken" class="mr-4">
          <UploadVideo />
        </div>
        <div>
          <NavbarLogged :isInStreamerPage="isInStreamerPage" v-if="isUserLoggedIn" />
        </div>

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
          @reset="resetCountdown"
        />
      </div>
    </div>
  </nav>
</template>
