<script setup>
import { Button } from '@/common/ui/button'
import CustomInput from '@/components/input-validation/CustomInput.vue'
import { useChangePassword } from '@/services/changepassword.services.js'
import { passwordSchema } from '@/validation/schema.js'
import { Eye, EyeOff } from 'lucide-vue-next'
import { useForm } from 'vee-validate'
import { computed, ref } from 'vue'
import { Input } from '@common/ui/input'
import BaseDialog from '../BaseDialog.vue'

const emit = defineEmits(['openChangePasswordResult'])

const oldPassword = ref('')
const errorMessage = ref('')
const showPassword = ref(false)
const showError = ref(false)

const mutation = useChangePassword()
const { isPending, isError } = mutation

const { values, errors, defineField, resetForm } = useForm({
  validationSchema: passwordSchema
})

const isFillAllFields = computed(() => {
  return values.password && values.confirmPassword && oldPassword.value
})

const isFormValid = computed(() => {
  return isFillAllFields.value
})

const submit = async () => {
  if (Object.keys(errors.value).length > 0) {
    showError.value = true
  } else {
    mutation.mutate(
      {
        currentPassword: oldPassword.value,
        newPassword: values.password
      },
      {
        onSuccess: () => {
          emit('openChangePasswordResult')
          resetFormOnClose()
        },
        onError: (error) => {
          errorMessage.value = error.response?.data?.message
        }
      }
    )
  }
}

const togglePasswordVisibility = () => {
  showPassword.value = !showPassword.value
}

const resetFormOnClose = () => {
  showError.value = false
  resetForm()
  oldPassword.value = ''
}

const handlePasswordInput = (event) => {
  const char = event.key
  if (char === ' ') {
    event.preventDefault();
  }
}

</script>

<template>
  <BaseDialog
    :title="$t('change_password.title')"
    :description="$t('change_password.desc')"
    @update:open="
      (val) => {
        if (!val) resetFormOnClose()
      }
    "
  >
    <form @submit.prevent="submit">
      <div class="flex flex-col space-y-1.5 mb-4">
        <label>{{ $t('change_password.old_password') }}</label>
        <div class="relative pb-2">
          <Input :type="showPassword ? 'text' : 'password'" v-model="oldPassword" maxlength="32" @keydown="handlePasswordInput" />
          <span
            @click="togglePasswordVisibility"
            class="absolute right-2 top-2 opacity-70 z-10 cursor-pointer"
          >
            <EyeOff v-if="!showPassword" />
            <Eye v-else />
          </span>
          <span v-if="isError" class="text-redMisc text-sm italic">{{
            errorMessage ? errorMessage : $t('change_password.fail_desc')
          }}</span>
        </div>
      </div>
      <div class="flex flex-col space-y-1.5 mb-4">
        <custom-input
          :label="$t('change_password.new_password')"
          name="password"
          :defineField="defineField"
          :errors="errors"
          inputType="password"
          :show-error="showError"
        />
      </div>

      <div class="flex flex-col space-y-1.5">
        <custom-input
          :label="$t('change_password.confirm_new_password')"
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
          >{{ $t('button.confirm') }}</Button
        >
      </div>
    </form>
  </BaseDialog>
</template>
