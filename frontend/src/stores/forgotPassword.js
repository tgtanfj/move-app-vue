import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useForgotPasswordStore = defineStore('forgotPassword', () => {
  const email = ref(
    localStorage.getItem('email') ? JSON.parse(localStorage.getItem('email')).email : ''
  )

  const setEmail = (newEmail) => {
    email.value = newEmail
    saveToLocal()
  }

  const saveToLocal = () => {
    localStorage.setItem(
      'email',
      JSON.stringify({
        email: email.value
      })
    )
  }

  return { email, setEmail }
})
