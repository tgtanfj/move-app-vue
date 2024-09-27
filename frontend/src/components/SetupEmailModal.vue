<template>
  <BaseDialog
    title="Setup your email."
    description="Your email is required to receive billing information & announcement from us. We will send you an OTP to your email to verify your account."
  >
    <form @submit.prevent="handleSendMail">
      <div class="flex flex-col space-y-1.5">
        <custom-input
          label="Enter email"
          name="email"
          :defineField="defineField"
          :errors="errors"
        />
      </div>

      <div class="flex justify-center mt-2">
        <Button
          type="submit"
          :disabled="!isFormValid"
          :variant="isFormValid ? 'default' : 'disabled'"
          class="w-[40%]"
          >Continue</Button
        >
      </div>
    </form>

    <div class="flex justify-center">
      <Button variant="link" @click="$emit('closeSetupEmailModal')"> Cancel </Button>
    </div>
  </BaseDialog>
</template>

<script setup>
import CustomInput from '@/components/input-validation/CustomInput.vue'
import { Button } from '@common/ui/button'
import BaseDialog from '@components/BaseDialog.vue'
import { useForm } from 'vee-validate'
import { computed } from 'vue'
import { emailSchema } from '../validation/schema'

const emit = defineEmits(['closeSetupEmailModal', 'handleSubmitForm'])

const { values, errors, defineField, handleSubmit } = useForm({
  validationSchema: emailSchema
})

const isFillAllFields = computed(() => {
  return values.email
})

const isFormValid = computed(() => {
  return isFillAllFields.value && Object.keys(errors.value).length === 0
})

const handleSendMail = handleSubmit(async (values) => {
  console.log(values)
  emit('handleSubmitForm')
})
</script>
