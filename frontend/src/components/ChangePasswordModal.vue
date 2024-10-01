<template>
  <BaseDialog :title="$t('change_password.title')" :description="$t('change_password.desc')">
    <form @submit="submit">
      <div class="flex flex-col space-y-1.5 mb-4">
        <label>{{ $t('change_password.old_password') }}</label>
        <Input type="password" />
      </div>
      <div class="flex flex-col space-y-1.5 mb-4">
        <custom-input
          :label="$t('change_password.new_password')"
          name="password"
          :defineField="defineField"
          :errors="errors"
          inputType="password"
        />
      </div>

      <div class="flex flex-col space-y-1.5">
        <custom-input
          :label="$t('change_password.confirm_new_password')"
          name="confirmPassword"
          :defineField="defineField"
          :errors="errors"
          inputType="password"
        />
      </div>

      <div class="text-center mt-6">
        <Button
          class="w-[60%]"
          :disabled="!isFormValid"
          :variant="isFormValid ? 'default' : 'disabled'"
          >{{ $t('button.confirm') }}</Button
        >
      </div>
    </form>
  </BaseDialog>
</template>

<script setup>
import { Button } from '@/common/ui/button'
import CustomInput from '@/components/input-validation/CustomInput.vue'
import { passwordSchema } from '@/validation/schema.js'
import { useForm } from 'vee-validate'
import { computed } from 'vue'
import { Input } from '../common/ui/input'
import BaseDialog from './BaseDialog.vue'

const emit = defineEmits(['openChangePasswordResult'])

const { values, errors, defineField, handleSubmit } = useForm({
  validationSchema: passwordSchema
})

const isFillAllFields = computed(() => {
  return values.password && values.confirmPassword
})

const isFormValid = computed(() => {
  return isFillAllFields.value && Object.keys(errors.value).length === 0
})

const submit = handleSubmit(() => {
  emit('openChangePasswordResult')
})
</script>
