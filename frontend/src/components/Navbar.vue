<template>
  <nav class="w-full bg-black text-white">
    <div class="flex items-center justify-between px-[40px] py-3">
      <ul class="flex flex-1 items-center gap-[35px]">
        <li class="font-semibold text-[16px]">Following</li>
        <li class="font-semibold text-[16px]">Browse</li>
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

      <div class="flex flex-1 items-center gap-2">
        <div class="flex flex-1 justify-end">
          <input
            type="text"
            class="w-[63%] max-w-[300px] rounded-[0.5rem_0_0_0.5rem] px-3 font-semibold text-black outline-none"
            placeholder="Search"
          />
          <Button class="w-[44px] rounded-[0_0.5rem_0.5rem_0]">
            <SearchIcon />
          </Button>
        </div>

        <div>
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
                  class="w-full m-auto border-b-[1px] border-[#999999] pb-0 rounded-none mb-3"
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
        <div>
          <NavbarLogged v-if="isUserLoggedIn" />
        </div>

        <ForgotPassword v-model:open="openForgotPassword" @open-login="openLoginModal" />
        <OTPVerificationModal
          v-model:open="openOTPModal"
          :signupInfo="signupInfo"
          @verify-success="handleVerifySuccess"
        />
      </div>
    </div>
  </nav>
</template>

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
import SignInModal from '@components/SignInModal.vue'
import { computed, ref } from 'vue'
import Button from '../common/ui/button/Button.vue'
import { useAuthStore } from '../stores/auth'
import ForgotPassword from './ForgotPassword.vue'
import OTPVerificationModal from './OTPVerificationModal.vue'
import SignUpModal from './SignUpModal.vue'

const isOpen = ref(false)
const openForgotPassword = ref(false)
const authStore = useAuthStore()

const isUserLoggedIn = computed(() => !!authStore.accessToken)

const closeModal = () => {
  isOpen.value = false
}

// const openForgotPassword = ref(false)
const openOTPModal = ref(false)
const signupInfo = ref('')

const onOpenForgotPassword = () => {
  openForgotPassword.value = true
  closeModal()
}

const openLoginModal = () => {
  isOpen.value = true
  openForgotPassword.value = false
}

// const authStore = useAuthStore()

// const isUserLoggedIn = computed(() => !!authStore.user.displayName)

const handleOpenOTPVerification = (values) => {
  openOTPModal.value = true
  signupInfo.value = values
}

const handleVerifySuccess = () => {
  openOTPModal.value = false
  isOpen.value = true
}
</script>
