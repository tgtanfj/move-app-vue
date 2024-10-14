<script setup>
import LogoBlack from '@assets/icons/LogoBlack.vue'
import LogoWhite from '@assets/icons/LogoWhite.vue'
import SearchIcon from '@assets/icons/SearchIcon.vue'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger
} from '@common/ui/dialog'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@common/ui/tabs'
import MoreMenuNav from '@components/MoreMenuNav.vue'
import NavbarLogged from '@components/NavbarLogged.vue'
import ForgotPassword from '@components/auth/ForgotPassword.vue'
import OTPVerificationModal from '@components/auth/OTPVerificationModal.vue'
import SignInModal from '@components/auth/SignInModal.vue'
import SignUpModal from '@components/auth/SignUpModal.vue'
import { computed, ref, watch } from 'vue'
import Button from '../common/ui/button/Button.vue'
import { useAuthStore } from '../stores/auth'
import { onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import UploadVideo from './upload-video/UploadVideo.vue'
import { useResetPasswordStore } from '../stores/resetPassword'

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
const resetPasswordStore = useResetPasswordStore()
const router = useRouter();
const route = useRoute()

watch(
  () => router.currentRoute.value, 
  () => {
    checkFromPasswordReset();
  }
);

onMounted(() => {
  const currentUrl = window.location.href
  if (currentUrl) {
    if (currentUrl.includes('/streamer')) {
      isInStreamerPage.value = true
    } else {
      isInStreamerPage.value = false
    }
    if (currentUrl.includes('/reset-password')) {
      isInResetPWPage.value = true
    } else {
      isInResetPWPage.value = false
    }
  }
})
const checkFromPasswordReset = () => {
  if (resetPasswordStore.fromResetPassword === true) {
    isOpen.value = true
    resetPasswordStore.toggleResetPasswordVariant()
  }
}

const isUserLoggedIn = computed(() => !!authStore.accessToken)

const checkStreamerStatus = (path) => {
  isInStreamerPage.value = path.includes('/streamer')
}

const checkResetPassword = (path) => {
  isInResetPWPage.value = path.includes('/reset-password')
}

checkStreamerStatus(route.path)

watch(
  () => route.path,
  (newPath) => {
    checkStreamerStatus(newPath)
  }
)

watch(
  () => route.path,
  (newPath) => {
    checkResetPassword(newPath)
  }
)

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
</script>

<template>
  <nav class="w-full bg-black text-white fixed z-50">
    <div
      class="flex items-center px-[40px] py-3"
      :class="{ 'justify-center': isInResetPWPage, 'justify-between': !isInResetPWPage }"
    >
      <ul v-if="!isInResetPWPage" class="flex flex-1 items-center gap-[35px]">
        <li class="font-semibold text-[16px]">Following</li>
        <li class="my-auto">
          <MoreMenuNav />
        </li>
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
          <input
            type="text"
            class="w-[63%] max-w-[300px] rounded-[0.5rem_0_0_0.5rem] px-3 font-semibold text-black outline-none"
            placeholder="Search"
          />
          <Button class="w-[44px] rounded-[0_0.5rem_0.5rem_0]">
            <SearchIcon />
          </Button>
        </div>

        <div :class="{ 'ml-auto': isInStreamerPage }">
          <Dialog v-model:open="isOpen" v-if="!isUserLoggedIn">
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
        <div v-if="isInStreamerPage" class="mr-4">
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
          @start="startCountdown"
          @reset="resetCountdown"
        />
      </div>
    </div>
  </nav>
</template>
