import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useOpenLoginStore = defineStore('openLogin', () => {
  const isOpenLogin = ref(false)

  const toggleOpenLogin = () => {
    isOpenLogin.value = !isOpenLogin.value
  }

  return {
    isOpenLogin,
    toggleOpenLogin
  }
})
