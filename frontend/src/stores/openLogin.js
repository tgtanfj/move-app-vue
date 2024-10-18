import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useOpenLoginStore = defineStore('openLogin', () => {
  const isOpenLogin = ref(false)
  const isSignUpFromSidebar = ref(false)

  const toggleOpenLogin = () => {
    isOpenLogin.value = !isOpenLogin.value
  }

  const handleClickSignUpFromSidebar = () => {
    isSignUpFromSidebar.value = true
  }

  const handleLeaveSignUpFromSidebar = () => {
    isSignUpFromSidebar.value = false
  }

  return {
    isOpenLogin,
    isSignUpFromSidebar,
    toggleOpenLogin,
    handleClickSignUpFromSidebar,
    handleLeaveSignUpFromSidebar
  }
})
