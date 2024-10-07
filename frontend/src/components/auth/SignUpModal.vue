<script setup lang="ts">
import FacebookIcon from '@assets/icons/FacebookIcon.vue'
import GoogleIcon from '@assets/icons/GoogleIcon.vue'
import { Button } from '@common/ui/button'
import { useToast } from '@common/ui/toast/use-toast'
import CustomInput from '@components/input-validation/CustomInput.vue'
import { useForm } from 'vee-validate'
import { computed, ref } from 'vue'
import { signupService } from '@services/signup.services'
import { useAuthStore } from '../../stores/auth'
import { registerSchema } from '../../validation/schema.js'

const props = defineProps({
  closeModal: Function
})

const errorsSignUp = ref('')
const showError = ref(false)
const isLoading = ref(false)
const authStore = useAuthStore()
const { toast } = useToast()

const emit = defineEmits(['openOtpVerification'])

const { handleSubmit, values, resetForm, errors, meta, defineField } = useForm({
  validationSchema: registerSchema
})

const toggleSignWithEmail = ref(false)

const handleToggleSignWithEmail = () => {
  toggleSignWithEmail.value = true
}

const isFillAllFields = computed(() => {
  return values.email && values.password && values.confirmPassword
})

const isSignUp = computed(() => {
  return isFillAllFields.value
})

const onSubmit = async () => {
  if (Object.keys(errors.value).length > 0) {
    showError.value = true
  } else {
    const email = values.email

    try {
      isLoading.value = true
      const data = await signupService.signupByEmailPassword(email)
      isLoading.value = false
      if (data.success === true) {
        props.closeModal()
        emit('openOtpVerification', values)
      }
    } catch (error) {
      isLoading.value = false
      console.error('Signup failed:', error)
      errorsSignUp.value = error.response.data.message
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
</script>

<template>
  <div class="flex flex-col justify-center gap-3 pb-3">
    <button
      class="flex items-center border-[#999999] border-[1px] p-1.5 rounded-lg"
      @click="handleGoogleSignIn"
    >
      <GoogleIcon />
      <p class="m-auto font-bold">Sign up with Google</p>
    </button>
    <button
      class="flex items-center border-[#999999] border-[1px] p-1.5 rounded-lg"
      @click="handleFacebookSignIn"
    >
      <FacebookIcon />
      <span class="m-auto font-bold">Sign up with Facebook</span>
    </button>
    <div class="flex items-center">
      <div class="border-b-[1px] border-[#999999] h-1 w-full"></div>
      <p class="w-52 text-center">or</p>
      <div class="border-b-[1px] border-[#999999] h-1 w-full"></div>
    </div>
    <p
      v-if="!toggleSignWithEmail"
      @click="handleToggleSignWithEmail"
      class="cursor-pointer font-bold text-[#13D0B4] text-center"
    >
      SIGN UP WITH EMAIL
    </p>
    <div v-if="toggleSignWithEmail">
      <form @submit.prevent="onSubmit" class="flex flex-col">
        <div class="flex flex-col gap-[4px]">
          <custom-input
            :label="$t('label.email')"
            name="email"
            :defineField="defineField"
            :errors="errors"
            :show-error="showError"
          />
        </div>
        <div v-if="errorsSignUp">
          <p class="text-destructive text-base mt-1">{{ errorsSignUp }}</p>
        </div>
        <div class="flex flex-col gap-[4px]">
          <custom-input
            :label="$t('label.password')"
            name="password"
            :defineField="defineField"
            :errors="errors"
            inputType="password"
            :show-error="showError"
          />
        </div>

        <div class="flex flex-col gap-[4px]">
          <custom-input
            :label="$t('label.confirm_password')"
            name="confirmPassword"
            :defineField="defineField"
            :errors="errors"
            inputType="password"
            :show-error="showError"
          />
        </div>

        <div class="flex flex-col gap-[4px] mb-2">
          <p class="text-sm text-darkGray">
            By clicking Sign Up, you are indicating that you have read and acknowledge the
            <span class="text-primary cursor-pointer">Terms of Service</span> and
            <span class="text-primary cursor-pointer">Privacy Notice</span>.
          </p>
        </div>

        <div>
          <Button
            class="w-full text-base"
            :disabled="!isSignUp || isLoading"
            :variant="isSignUp ? 'default' : 'disabled'"
            type="submit"
            :isLoading="isLoading"
            >Sign Up
          </Button>
        </div>
      </form>
    </div>
  </div>
</template>
