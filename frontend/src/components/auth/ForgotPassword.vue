<script setup>
import CustomInput from '@/components/input-validation/CustomInput.vue'
import { Button } from '@common/ui/button'
import BaseDialog from '@components/BaseDialog.vue'
import { useForm } from 'vee-validate'
import { computed, ref } from 'vue'
import { useForgotPassword } from '../../services/forgotpassword.services'
import { emailSchema } from '../../validation/schema'

const emit = defineEmits(['openLogin'])
const email = ref('')
const showError = ref(false)
const mutation = useForgotPassword()
const isBanned = ref(false)
const { isPending, isIdle, isSuccess, isError, reset } = mutation
let banned

const bgColor = computed(() => {
  if (isSuccess.value) {
    return 'bg-[#E6FFFB] border-primary'
  }
  if (isError.value) {
    return 'bg-[#FDEDEF] border-redMisc'
  }
  return ''
})

const { values, errors, defineField, handleSubmit, resetForm } = useForm({
  validationSchema: emailSchema
})

const isFillAllFields = computed(() => {
  return values.email
})

const isFormValid = computed(() => {
  return isFillAllFields.value
})

const handleSendMail = async () => {
  if (Object.keys(errors.value).length > 0) {
    showError.value = true
  } else {
    email.value = values.email
    mutation.mutate(
      { email: values.email },
      {
        onSuccess: () => {
          isBanned.value = true
          banned = setTimeout(() => {
            isBanned.value = false
          }, 60000)
        }
      }
    )
  }
}

const openLogin = () => {
  resetFormOnClose()
  emit('openLogin')
}

const resetFormOnClose = () => {
  resetForm()
  reset()
  showError.value = false
}

const clearErrorAPI = () => {
  reset()
}
</script>

<template>
  <BaseDialog
    :title="$t('forgot_password.title')"
    :description="$t('forgot_password.desc')"
    @update:open="
      (val) => {
        if (!val) resetFormOnClose()
      }
    "
  >
    <form @submit.prevent="handleSendMail">
      <div class="flex flex-col space-y-1.5">
        <custom-input
          name="email"
          :defineField="defineField"
          :errors="errors"
          :show-error="showError"
          @clearErrorAPI="clearErrorAPI"
        />
      </div>
      <div
        v-if="(isSuccess && !isPending) || (isError && !isPending)"
        class="border rounded-md px-3 py-5 text-center"
        :class="bgColor"
      >
        <span v-if="isSuccess" class="max-w-[400px] m-auto">
          {{ $t('forgot_password.send_mail_success', { email }) }}
        </span>
        <p v-if="isError" class="max-w-[400px] m-auto text-redMisc">
          {{ $t('forgot_password.send_mail_error', { email }) }}
        </p>
      </div>

      <div class="flex justify-center mt-3">
        <Button
          type="submit"
          :disabled="!isFormValid || isPending || isBanned"
          :variant="isFormValid ? 'default' : 'disabled'"
          :isLoading="isPending"
          >{{
            isIdle
              ? $t('forgot_password.send_link')
              : isSuccess
                ? $t('forgot_password.resend_link')
                : $t('forgot_password.send_link')
          }}</Button
        >
      </div>
    </form>

    <div class="flex justify-center">
      <Button variant="link" @click="openLogin"> {{ $t('button.back_to_login') }} </Button>
    </div>
  </BaseDialog>
</template>
