<script setup>
import { Button } from '@/common/ui/button'
import BaseCard from '@/components/BaseCard.vue'
import CustomInput from '@/components/input-validation/CustomInput.vue'
import { passwordSchema } from '@/validation/schema.js'
import { useForm } from 'vee-validate'
import { computed, ref } from 'vue'
import { RouterLink, useRoute } from 'vue-router'
import { useResetPassword } from '../services/forgotpassword.services'

const route = useRoute()
const token = route.params.token
const mutationResetPassword = useResetPassword()
const { isPending, isSuccess, isError } = mutationResetPassword

const isFillAllFields = computed(() => {
  return values.password && values.confirmPassword
})
const isFormValid = computed(() => {
  return isFillAllFields.value && Object.keys(errors.value).length === 0
})

const { values, errors, defineField, handleSubmit } = useForm({
  validationSchema: passwordSchema
})
const submit = handleSubmit(async (values) => {
  mutationResetPassword.mutate({
    token: token,
    newPassword: values.password
  })
})
// const handleResendLink = () => {
//   mutationForgotPassword.mutate({ email: forgotPasswordStore.email })
// }
</script>

<template>
  <BaseCard
    v-if="!isSuccess && !isError"
    :title="$t('forgot_password.create_password')"
    :description="$t('forgot_password.create_password_desc')"
  >
    <form @submit="submit">
      <div class="flex flex-col space-y-1.5 mb-4">
        <custom-input
          :label="$t('label.password')"
          name="password"
          :defineField="defineField"
          :errors="errors"
          inputType="password"
        />
      </div>

      <div class="flex flex-col space-y-1.5">
        <custom-input
          :label="$t('label.confirm_password')"
          name="confirmPassword"
          :defineField="defineField"
          :errors="errors"
          inputType="password"
        />
      </div>

      <div class="text-center mt-6">
        <Button
          class="w-[60%]"
          :disabled="!isFormValid || isPending"
          :variant="isFormValid ? 'default' : 'disabled'"
          >{{ isPending ? 'Loading...' : 'Confirm' }}
        </Button>
      </div>
    </form>
  </BaseCard>

  <BaseCard
    v-if="isSuccess || isError"
    :title="
      isSuccess ? $t('forgot_password.reset_success_title') : $t('forgot_password.reset_fail_title')
    "
    :description="
      isSuccess ? $t('forgot_password.reset_success_desc') : $t('forgot_password.reset_fail_desc')
    "
  >
    <!-- <p v-if="isError">
      <Button variant="link" class="p-0" @click="handleResendLink">{{
        $t('forgot_password.resend_link')
      }}</Button>
      to
      <b>{{ forgotPasswordStore.email }}</b>
    </p> -->

    <div class="text-center mt-6">
      <Button class="w-[60%]">
        <RouterLink to="/">{{
          isSuccess ? $t('button.login') : $t('button.back_to_home')
        }}</RouterLink>
      </Button>
    </div>
  </BaseCard>
</template>
