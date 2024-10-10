<script setup>
import { Button } from '@/common/ui/button'
import BaseCard from '@/components/BaseCard.vue'
import CustomInput from '@/components/input-validation/CustomInput.vue'
import { passwordSchema } from '@/validation/schema.js'
import { useForm } from 'vee-validate'
import { computed, ref } from 'vue'
import { RouterLink, useRoute } from 'vue-router'
import { useResetPassword } from '../services/forgotpassword.services'

const showError = ref(false)
const route = useRoute()
const token = route.params.token
const mutationResetPassword = useResetPassword()
const { isPending, isSuccess, isError } = mutationResetPassword

const isFillAllFields = computed(() => {
  return values.password && values.confirmPassword
})
const isFormValid = computed(() => {
  return isFillAllFields.value
})

const { values, errors, defineField, handleSubmit } = useForm({
  validationSchema: passwordSchema
})

const submit = async () => {
  if (Object.keys(errors.value).length > 0) {
    showError.value = true
  } else {
    mutationResetPassword.mutate({
      token: token,
      newPassword: values.password
    })
  }
}
</script>

<template>
  <BaseCard
    v-if="!isSuccess && !isError"
    :title="$t('forgot_password.create_password')"
    :description="$t('forgot_password.create_password_desc')"
    class="mt-0"
  >
    <form @submit.prevent="submit">
      <div class="flex flex-col space-y-1.5 mb-4">
        <custom-input
          :label="$t('label.new_password')"
          name="password"
          :defineField="defineField"
          :errors="errors"
          inputType="password"
          :show-error="showError"
        />
      </div>

      <div class="flex flex-col space-y-1.5">
        <custom-input
          :label="$t('label.confirm_new_password')"
          name="confirmPassword"
          :defineField="defineField"
          :errors="errors"
          inputType="password"
          :show-error="showError"
        />
      </div>

      <div class="text-center mt-6">
        <Button
          class="w-[60%]"
          :disabled="!isFormValid || isPending"
          :variant="isFormValid ? 'default' : 'disabled'"
          :isLoading="isPending"
          >{{ $t('button.confirm') }}
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
    <div class="text-center mt-6">
      <Button class="w-[60%]">
        <RouterLink to="/">{{
          isSuccess ? $t('button.login') : $t('button.back_to_home')
        }}</RouterLink>
      </Button>
    </div>
  </BaseCard>
</template>
