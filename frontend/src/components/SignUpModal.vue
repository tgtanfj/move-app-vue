<script setup lang="ts">
import GoogleIcon from '@assets/icons/GoogleIcon.vue'
import FacebookIcon from '@assets/icons/FacebookIcon.vue'
import * as yup from 'yup'
import { useForm, Field, ErrorMessage, Form as VForm } from 'vee-validate'
import { Button } from '@common/ui/button'
import { computed, ref } from 'vue'
import { registerSchema } from '../validation/schema.js'

const props = defineProps({
  closeModal: Function
})



const { handleSubmit, values, resetForm, errors, meta } = useForm({
  validationSchema :registerSchema
})

const toggleSignWithEmail = ref(false)

const handleToggleSignWithEmail = () => {
  toggleSignWithEmail.value = true
}

const isFillAllFields = computed(() => {
  return values.email && values.password && values.confirmPassword
})

const isSignUp = computed(() => {
  return isFillAllFields.value && Object.keys(errors.value).length === 0
})

const onSubmit = handleSubmit((values) => {
  console.log('Form Values:', values)
  props.closeModal()
})
</script>

<template>
  <div class="flex flex-col justify-center gap-3 pb-3">
    <button class="flex items-center border-[#999999] border-[1px] p-1.5 rounded-lg">
      <GoogleIcon />
      <p class="m-auto font-bold">Log In with Google</p>
    </button>
    <button class="flex items-center border-[#999999] border-[1px] p-1.5 rounded-lg">
      <FacebookIcon />
      <span class="m-auto font-bold">Log In with Facebook</span>
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
      <form @submit="onSubmit" class="flex flex-col gap-1">
        <div class="flex flex-col gap-[4px] mb-2">
          <label for="email">Email</label>
          <Field
            id="email"
            name="email"
            type="email"
            class="px-3 py-2 border-[1px] focus:border-[#13D0B4] outline-none rounded-lg border-lightGray"
            v-model="values.email"
            as="input"
          />
          <ErrorMessage name="email" class="text-sm text-destructive" />
        </div>

        <div class="flex flex-col gap-[4px] mb-2">
          <label for="password">Password</label>
          <Field
            id="password"
            name="password"
            type="password"
            class="px-3 py-2 border-[1px] focus:border-[#13D0B4] outline-none rounded-lg border-lightGray"
            v-model="values.password"
            as="input"
          />
          <ErrorMessage name="password" class="text-sm text-destructive" />
        </div>

        <div class="flex flex-col gap-[4px] mb-2">
          <label for="confirmPassword">Confirm Password</label>
          <Field
            id="confirmPassword"
            name="confirmPassword"
            type="password"
            class="px-3 py-2 border-[1px] focus:border-[#13D0B4] outline-none rounded-lg border-lightGray"
            v-model="values.confirmPassword"
            as="input"
          />
          <ErrorMessage name="confirmPassword" class="text-sm text-destructive" />
        </div>

        <div class="flex flex-col gap-[4px] mb-2">
          <label for="code">Referral code (Optional)</label>
          <Field
            id="code"
            name="code"
            type="text"
            class="px-3 py-2 border-[1px] focus:border-[#13D0B4] outline-none rounded-lg border-lightGray"
            v-model="values.code"
            as="input"
          />
          <ErrorMessage name="code" class="text-sm text-destructive" />
        </div>

        <div class="flex flex-col gap-[4px] mb-2">
          <p class="text-sm text-darkGray">
            By clicking Sign Up, you are indicating that you have read and acknowledge the
            <span class="text-primary cursor-pointer">Terms of Service</span> and
            <span class="text-primary cursor-pointer">Privacy Notice</span>.
          </p>
        </div>

        <Button
          class="w-full text-base"
          :disabled="!isSignUp"
          :variant="isSignUp ? 'default' : 'disabled'"
          type="submit"
          >Sign Up</Button
        >
      </form>
    </div>
  </div>
</template>
