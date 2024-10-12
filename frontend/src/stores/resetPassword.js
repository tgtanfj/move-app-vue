import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useResetPasswordStore = defineStore('resetPassword', () => {
  const fromResetPassword = ref(false)

  const toggleResetPasswordVariant = () => {
    fromResetPassword.value = !fromResetPassword.value
  }

  return {
    fromResetPassword,
    toggleResetPasswordVariant
  }
})
