<script setup>
import FacebookIcon from '@assets/icons/FacebookIcon.vue'
import GoogleIcon from '@assets/icons/GoogleIcon.vue'
import Button from '@common/ui/button/Button.vue'
import { useToast } from '@common/ui/toast/use-toast'
import { Eye, EyeOff } from 'lucide-vue-next'
import { useForm } from 'vee-validate'
import { computed, ref } from 'vue'
import { useAuthStore } from '../../stores/auth'
import { signinSchema } from '../../validation/schema'
import { useFollowerStore } from '../../stores/follower.store'

const props = defineProps({
  closeModal: Function
})
//Handle open forgot password
const emit = defineEmits(['openForgotPassword'])

const { values, errors, defineField, handleSubmit } = useForm({
  validationSchema: signinSchema
})

const formLogin = ref(false)
const showPassword = ref(false)
const showError = ref(false)
const [email, emailAttrs] = defineField('email')
const [password, passwordAttrs] = defineField('password')
const { toast } = useToast()
const authStore = useAuthStore()
const followerStore = useFollowerStore()

const isFillAllFields = computed(() => {
  return values.email && values.password
})

const isSignIn = computed(() => {
  return isFillAllFields.value
})

const handleSignIn = async () => {
  if (Object.keys(errors.value).length > 0) {
    showError.value = true
  } else {
    await authStore.loginWithEmail(values)
    if (authStore.accessToken) {
      followerStore.getAllFollowers()
      props.closeModal()
      toast({ description: 'Login successfully', variant: 'successfully' })
    } else {
      showError.value = true
    }
  }
}

const handleGoogleSignIn = async () => {
  try {
    await authStore.googleSignIn()

    if (authStore.idToken) {
      await authStore.sendTokenToBackend()

      if (authStore.accessToken) {
        props.closeModal()
        toast({ description: 'Login successfully', variant: 'successfully' })
      }
    }
  } catch (error) {
    console.log('Error during Google login or backend token submission:', error)
    toast({
      description:
        authStore.errorMsg ||
        'An account with this email already exists using a different login method. Please use the original method to log in',
      variant: 'destructive'
    })
  } finally {
    authStore.isLoading = false
  }
}

const handleFacebookSignIn = async () => {
  try {
    await authStore.facebookSignIn()

    if (authStore.idToken) {
      await authStore.sendTokenToBackend()

      if (authStore.accessToken) {
        props.closeModal()
        toast({ description: 'Login successfully', variant: 'successfully' })
      }
    }
  } catch (error) {
    console.log('Error during Google login or backend token submission:', error)
    toast({
      description:
        authStore.errorMsg ||
        'An account with this email already exists using a different login method. Please use the original method to log in',
      variant: 'destructive'
    })
  } finally {
    authStore.isLoading = false
  }
}

const togglePasswordVisibility = () => {
  showPassword.value = !showPassword.value
}
const handleOpenForgotPassword = () => {
  emit('openForgotPassword')
}

const handlePasswordInput = (event) => {
  const char = event.key
  if (char === ' ') {
    event.preventDefault();
  } else {
    authStore.errorMsg = '' 
  }
}

const handleInput = () => {
  authStore.errorMsg = ''
}
</script>

<template>
  <div class="w-full flex flex-col justify-center gap-3 pb-3">
    <button
      class="flex items-center border-[#999999] border-[1px] p-1.5 rounded-lg"
      @click="handleGoogleSignIn"
    >
      <GoogleIcon />
      <span class="m-auto font-bold">{{ $t('login.google') }}</span>
    </button>
    <button
      class="flex items-center border-[#999999] border-[1px] p-1.5 rounded-lg"
      @click="handleFacebookSignIn"
    >
      <FacebookIcon />
      <p class="m-auto font-bold">{{ $t('login.facebook') }}</p>
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
    {{ $t('login.email') }}
    </p>

    <form @submit.prevent="handleSignIn" v-if="formLogin" class="flex flex-col gap-1" novalidate>
      <div class="mb-2 flex flex-col">
        <label class="mb-2">{{ $t('label.email') }}</label>
        <input
          type="email"
          class="text-[16px] mb-1 py-2 px-3 border-darkGray border-[1px] rounded-lg focus:border-[#13D0B4] focus:outline-none"
          :class="showError && errors.email ? 'border-redMisc' : ''"
          v-model.trim="email"
          v-bind="emailAttrs"
          @input="handleInput"
          maxlength="255"
        />
        <p v-if="showError && errors.email" class="text-red-500 text-[14px]">{{ errors.email }}</p>
      </div>
      <div class="mb-2 flex flex-col">
        <label class="mb-2">{{ $t('label.password') }}</label>
        <div class="relative">
          <input
            :type="showPassword ? 'text' : 'password'"
            class="py-2 px-3 mb-1 border-darkGray border-[1px] rounded-lg focus:border-[#13D0B4] focus:outline-none z-0 w-full"
            :class="showError && errors.password ? 'border-redMisc' : ''"
            v-model="password"
            v-bind="passwordAttrs"
            maxlength="32"
            @keydown="handlePasswordInput"
          />
          <span
            @click="togglePasswordVisibility"
            class="absolute right-2 top-2 opacity-70 z-10 cursor-pointer"
          >
            <EyeOff v-if="!showPassword" />
            <Eye v-else />
          </span>
        </div>
        <p v-if="showError && errors.password" class="text-red-500 text-[14px]">
          {{ errors.password }}
        </p>
      </div>
      <p v-if="showError && authStore.errorMsg" class="text-red-500 text-[14px]">
        {{ authStore.errorMsg }}
      </p>
      <div class="ml-[-10px]">
        <Button variant="link" type="button" @click="handleOpenForgotPassword">
          {{ $t('login.forgot_password') }}
        </Button>
      </div>
      <Button
        type="submit"
        :disabled="!isSignIn || authStore.isLoading"
        :variant="isSignIn ? 'default' : 'disabled'"
        :isLoading="authStore.isLoading"
      >
        Log In
      </Button>
    </form>
  </div>
</template>
