<template>
  <BaseCard
    title="Create new password"
    description="Please enter your new password and make sure your password is alphanumeric with at least 8 characters."
  >
    <form @submit="submit">
      <div class="flex flex-col space-y-1.5 mb-4">
        <custom-input
          label="Password"
          name="password"
          :defineField="defineField"
          :errors="errors"
          inputType="password"
        />
      </div>

      <div class="flex flex-col space-y-1.5">
        <custom-input
          label="Confirm password"
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
          >Confirm</Button
        >
      </div>
    </form>
  </BaseCard>

  <BaseCard
    title="Reset password success"
    description="Good news! You are just few steps away to login to MOVE. Click on the button below to login."
    v-if="false"
  >
    <div class="text-center mt-6">
      <Button class="w-[60%]"><RouterLink to="/">Login</RouterLink></Button>
    </div>
  </BaseCard>
</template>

<script setup>
import { Button } from '@/common/ui/button'
import BaseCard from '@/components/BaseCard.vue'
import CustomInput from '@/components/input-validation/CustomInput.vue'
import { passwordSchema } from '@/validation/schema.js'
import { useForm } from 'vee-validate'
import { computed } from 'vue'
import { RouterLink } from 'vue-router'

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
  console.log(values.password)
})
</script>
