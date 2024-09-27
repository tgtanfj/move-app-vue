<template>
  <nav class="w-full bg-black text-white">
    <div class="flex items-center justify-between px-[40px] py-3">
      <ul class="flex flex-[0.3] items-center gap-[35px] text-[18px]">
        <li class="font-semibold">Following</li>
        <li class="font-semibold">Browse</li>
        <li class="my-auto">
          <DotDotDot />
        </li>
      </ul>

      <div class="flex-[0.3]">
        <div class="m-auto w-28">
          <LogoWhite />
        </div>
      </div>

      <div class="flex flex-[0.3] justify-end">
        <div class="flex">
          <input
            type="text"
            class="w-[252px] rounded-[0.5rem_0_0_0.5rem] px-3 text-black outline-none"
            placeholder="Search"
          />
          <Button variant="default" class="w-12 rounded-[0_0.5rem_0.5rem_0]">
            <SearchIcon />
          </Button>

          <Dialog v-model:open="isOpen">
            <DialogTrigger>
              <Button variant="default" class="ml-4 rounded-lg">Log In</Button>
            </DialogTrigger>
            <DialogContent>
              <DialogHeader class="relative">
                <DialogTitle class="w-24 m-auto">
                  <LogoBlack />
                </DialogTitle>
              </DialogHeader>

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
                <TabsContent value="login" class="">
                  <SignInModal
                    :closeModal="closeModal"
                    @openForgotPassword="onOpenForgotPassword"
                  />
                </TabsContent>
                <TabsContent value="signup">
                  <SignUpModal
                    :closeModal="closeModal"
                    @open-otp-verification="openOTPModal = true"
                  />
                </TabsContent>
              </Tabs>
            </DialogContent>
          </Dialog>
          <ForgotPassword v-model:open="openForgotPassword" @open-login="openLoginModal" />
          <OTPVerificationModal v-model:open="openOTPModal" />
        </div>
      </div>
    </div>
  </nav>
</template>

<script setup>
import DotDotDot from '@assets/icons/DotDotDot.vue'
import LogoBlack from '@assets/icons/LogoBlack.vue'
import LogoWhite from '@assets/icons/LogoWhite.vue'
import SearchIcon from '@assets/icons/SearchIcon.vue'
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from '@common/ui/dialog'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@common/ui/tabs'
import SignInModal from '@components/SignInModal.vue'
import { ref } from 'vue'
import Button from '../common/ui/button/Button.vue'
import ForgotPassword from './ForgotPassword.vue'
import OTPVerificationModal from './OTPVerificationModal.vue'
import SignUpModal from './SignUpModal.vue'
const isOpen = ref(false)

const openModal = () => {
  isOpen.value = true
}

const closeModal = () => {
  isOpen.value = false
}

const openForgotPassword = ref(false)
const openOTPModal = ref(false)

const onOpenForgotPassword = () => {
  openForgotPassword.value = true
  closeModal()
}
const openLoginModal = () => {
  isOpen.value = true
  openForgotPassword.value = false
}
</script>
