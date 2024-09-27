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

      <div class="flex-1">
        <div class="m-auto w-28">
          <LogoWhite />
        </div>
      </div>

      <div class="flex flex-1 gap-6 justify-end">
        <div class="flex">
          <input
            type="text"
            class="w-[252px] rounded-[0.5rem_0_0_0.5rem] px-3 text-black outline-none"
            placeholder="Search"
          />
          <Button variant="default" class="w-12 rounded-[0_0.5rem_0.5rem_0]">
            <SearchIcon />
          </Button>

          <Dialog v-model:open="isOpen" v-if="!isUserLoggedIn">
            <DialogTrigger>
              <Button variant="" class="ml-4 rounded-lg">Log In</Button>
            </DialogTrigger>

            <DialogContent>
              <DialogHeader class="relative">
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
                <TabsContent value="login" class="">
                  <SignInModal
                    :closeModal="closeModal"
                    @openForgotPassword="onOpenForgotPassword"
                  />
                </TabsContent>
                <TabsContent value="signup">
                  <SignUpModal :closeModal="closeModal" />
                </TabsContent>
              </Tabs>
            </DialogContent>
          </Dialog>
        </div>
        <div>
          <NavbarLogged v-if="isUserLoggedIn" />
        </div>

        <ForgotPassword v-model:open="openForgotPassword" @open-login="openLoginModal" />
      </div>
    </div>
  </nav>
</template>

<script setup>
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger, DialogDescription } from '@common/ui/dialog'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@common/ui/tabs'
import SignInModal from '@components/SignInModal.vue'
import { computed, ref } from 'vue'
import Button from '../common/ui/button/Button.vue'
import ForgotPassword from './ForgotPassword.vue'
import SignUpModal from './SignUpModal.vue'
import LogoBlack from '@assets/icons/LogoBlack.vue'
import LogoWhite from '@assets/icons/LogoWhite.vue'
import SearchIcon from '@assets/icons/SearchIcon.vue'
import { useAuthStore } from '../stores/auth'
import NavbarLogged from '@components/NavbarLogged.vue'
import MoreMenuNav from '@components/MoreMenuNav.vue'
const isOpen = ref(false)

const closeModal = () => {
  isOpen.value = false
}

const openForgotPassword = ref(false)
const onOpenForgotPassword = () => {
  openForgotPassword.value = true
  closeModal()
}
const openLoginModal = () => {
  isOpen.value = true
  openForgotPassword.value = false
}

const authStore = useAuthStore()

const isUserLoggedIn = computed(() => !!authStore.user.displayName)
</script>
