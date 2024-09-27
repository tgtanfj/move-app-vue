<script setup>
import FacebookIcon from '@assets/icons/FacebookIcon.vue'
import GoogleIcon from '@assets/icons/GoogleIcon.vue'
import Button from '@common/ui/button/Button.vue'
import { useAuthStore } from '../stores/auth'
const props = defineProps({
  closeModal: Function
})

import { useForm } from 'vee-validate'
import { computed, ref } from 'vue'
import { signinSchema } from '../validation/schema'

const { values, errors, defineField, handleSubmit } = useForm({
  validationSchema: signinSchema
})

const [email, emailAttrs] = defineField('email')
const [password, passwordAttrs] = defineField('password')

const authStore = useAuthStore()

const isFillAllFields = computed(() => {
  return values.email && values.password
})

const isSignIn = computed(() => {
  return isFillAllFields.value && Object.keys(errors.value).length === 0
})

const handleSignIn = handleSubmit(async (values) => {
  props.closeModal()
})

const handleGoogleSignIn = async () => {
  await authStore.googleSignIn()
  if (authStore.user) {
    props.closeModal()
  }
}

const formLogin = ref(false)

//Handle open forgot password
const emit = defineEmits(['openForgotPassword'])
const handleOpenForgotPassword = () => {
  emit('openForgotPassword')
}
</script>

<template>
  <div class="w-full flex flex-col justify-center gap-3 pb-3">
    <button
      class="flex items-center border-[#999999] border-[1px] p-1.5 rounded-lg"
      @click="handleGoogleSignIn"
    >
      <GoogleIcon />
      <span class="m-auto font-bold">Log In with Google</span>
    </button>
    <button
      class="flex items-center border-[#999999] border-[1px] p-1.5 rounded-lg"
      @click="handleFacebookSignIn"
    >
      <FacebookIcon />
      <p class="m-auto font-bold">Log In with Facebook</p>
    </button>
    <div class="flex items-center">
      <div class="border-b-[1px] border-[#999999] h-1 w-full"></div>
      <p class="w-52 text-center">or</p>
      <div class="border-b-[1px] border-[#999999] h-1 w-full"></div>
    </div>
    <p
      class="font-bold text-[#13D0B4] text-center cursor-pointer"
      @click="formLogin = true"
      v-if="!formLogin"
    >
      LOG IN WITH EMAIL
    </p>

    <form @submit.prevent="handleSignIn" v-if="formLogin" class="flex flex-col gap-1" novalidate>
      <div class="mb-2 flex flex-col">
        <label class="mb-2">Email</label>
        <input
          type="email"
          class="text-[16px] mb-1 py-2 px-3 border-darkGray border-[1px] rounded-lg focus:border-[#13D0B4] focus:outline-none"
          v-model="email"
          v-bind="emailAttrs"
        />
        <p class="text-red-500 text-[14px]">{{ errors.email }}</p>
      </div>
      <div class="mb-2 flex flex-col">
        <label class="mb-2">Password</label>
        <input
          type="password"
          class="py-2 px-3 mb-1 border-darkGray border-[1px] rounded-lg focus:border-[#13D0B4] focus:outline-none"
          v-model="password"
          v-bind="passwordAttrs"
        />
        <p class="text-red-500 text-[14px]">{{ errors.password }}</p>
      </div>
      <div class="ml-[-10px]">
        <Button variant="link" @click="handleOpenForgotPassword">Forgot password?</Button>
      </div>
      <Button type="submit" :disabled="!isSignIn" :variant="isSignIn ? 'default' : 'disabled'"
        >Log In</Button
      >
    </form>
  </div>
</template>
