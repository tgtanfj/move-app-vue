<script setup>
import { Button } from '@common/ui/button'
import { Input } from '@common/ui/input'
import { computed, ref } from 'vue'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger
} from '@common/ui/dialog'
import { commentServices } from '@services/comment.services'
import { ref } from 'vue'
import defaultAvatar from '../../assets/icons/default-avatar.png'
import { useAuthStore } from '../../stores/auth'
import LogoBlack from '@assets/icons/LogoBlack.vue'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@common/ui/tabs'
import SignInModal from '@components/auth/SignInModal.vue'
import SignUpModal from '@components/auth/SignUpModal.vue'
import ForgotPassword from '@components/auth/ForgotPassword.vue'
import OTPVerificationModal from '@components/auth/OTPVerificationModal.vue'

const props = defineProps({
  videoId: {
    type: String,
    required: true
  },
  me: {
    type: Object,
    required: true
  },
  comments: {
    type: Array,
    required: true
  }
})

const emit = defineEmits(['update'])

const authStore = useAuthStore()

const isUserLoggedIn = computed(() => !!authStore.accessToken)

const isCancelComment = ref(false)
const isFocused = ref(false)
const comment = ref('')
const isOpen = ref(false)
const openForgotPassword = ref(false)
const openOTPModal = ref(false)
const signupInfo = ref('')
let timer = null
const countdown = ref(60)
const isCounting = ref(false)
const isLoginAttempted = ref(false)
const isModalOpen = ref(false)
const inputRef = ref(null)

const handleBlur = () => {
  if (!comment.value) {
    isFocused.value = false
  }
}

const cancelComment = () => {
  isCancelComment.value = false
  comment.value = ''
  isFocused.value = false
}

const handleCloseEsc = (event) => {
  event.preventDefault()
  isCancelComment.value = true
}

const postCommentVideo = async () => {
  if (Object.keys(authStore.user).length === 0) {
    isOpen.value = true
  } else {
    if (!comment.value) return
    const data = await commentServices.postComment(comment.value)
    if (data.message === 'success') {
      emit('update', data?.data)
      comment.value = ''
    } else {
      return
    }
  }
}

const handleClickNo = () => {
  isCancelComment.value = false
}

const handleFocus = () => {
  isFocused.value = true
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

const handleClickInput = () => {
  if (Object.keys(authStore.user).length === 0) {
    isOpen.value = true
    isFocused.value = false
    handleBlur()
  }
}
</script>

<template>
  <div class="w-full flex flex-col items-end gap-4">
    <div class="w-full flex items-center gap-4">
      <img
        :src="me?.photoURL ? me?.photoURL : defaultAvatar"
        class="w-[40px] h-[40px] rounded-full object-cover"
      />
      <Input
        :ref="inputRef"
        v-model="comment"
        @click="handleClickInput"
        @focus="handleFocus"
        @keydown.enter="postCommentVideo"
        @keydown.esc="handleCloseEsc"
        @blur="handleBlur"
        placeholder="Write a comment"
        class="outline-none rounded-none border-t-0 border-r-0 border-l-0 border-b-2 border-[#e2e2e2] py-5 px-0 placeholder:text-[13px] placeholder:text-[#666666]"
      />
    </div>
    <div v-if="isFocused" class="flex items-center justify-end gap-4">
      <Dialog v-model:open="isCancelComment">
        <DialogTrigger aschild>
          <Button class="text-[16px] font-normal" variant="outline">{{
            $t('comment.cancel')
          }}</Button>
        </DialogTrigger>
        <DialogContent class="w-[400px] p-4">
          <p class="text-2xl font-bold">{{ $t('comment.cancel_reservation') }}</p>
          <p>{{ $t('comment.are_you_sure') }}</p>
          <div class="w-full flex items-center justify-center gap-4 mt-4">
            <Button @click="handleClickNo" class="w-24 font-normal" variant="outline">{{
              $t('comment.no')
            }}</Button>
            <Button @click="cancelComment" class="w-24">{{ $t('comment.yes') }}</Button>
          </div>
        </DialogContent>
      </Dialog>
      <Button @click="postCommentVideo" class="w-[104px] text-[16px]">{{
        $t('comment.send')
      }}</Button>
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
  </div>
</template>
