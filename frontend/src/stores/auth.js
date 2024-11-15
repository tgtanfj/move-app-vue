import { defineStore } from 'pinia'
import {
  signInWithPopup,
  GoogleAuthProvider,
  signOut,
  onAuthStateChanged,
  FacebookAuthProvider
} from 'firebase/auth'
import { auth } from '../services/firebaseConfig.js'
import { onMounted, ref } from 'vue'
import axios from 'axios'
import { ADMIN_BASE } from '@constants/api.constant.js'
import defaultAvatar from '@assets/images/default-avatar.png'
import { apiAxios } from '@helpers/axios.helper.js'

export const useAuthStore = defineStore('auth', () => {
  // States
  const user = ref({})
  const usernameUser = ref(null)
  const errorMsg = ref(null)
  const idToken = ref(null)
  const accessToken = ref(null)
  const refreshToken = ref(null)
  const isLoading = ref(false)
  const emailFirebase = ref(null)
  const blueBadge = ref(null)
  const channelId = ref(null)

  // Actions
  const googleSignIn = async () => {
    // Login with Google
    const provider = new GoogleAuthProvider()
    provider.addScope('email')
    provider.setCustomParameters({ prompt: 'select_account' })
    try {
      const result = await signInWithPopup(auth, provider)
      user.value = result.user
      idToken.value = await user.value.getIdToken()
      emailFirebase.value = await result._tokenResponse.email
      localStorage.setItem('loginMethod', 'google')
    } catch (err) {
      if (err.code === 'auth/popup-closed-by-user' || err.code === 'auth/cancelled-popup-request') {
        isLoading.value = false
      } else {
        console.error('Error during Google login:', err)
        throw err
      }
    } finally {
      isLoading.value = false
    }
  }

  const facebookSignIn = async () => {
    // Login with Facebook
    const provider = new FacebookAuthProvider()
    provider.addScope('email')
    provider.setCustomParameters({ prompt: 'select_account' })
    try {
      const result = await signInWithPopup(auth, provider)
      user.value = result.user
      idToken.value = await user.value.getIdToken()
      emailFirebase.value = await result._tokenResponse.email
      localStorage.setItem('loginMethod', 'facebook')
    } catch (err) {
      if (err.code === 'auth/popup-closed-by-user' || err.code === 'auth/cancelled-popup-request') {
        isLoading.value = false
      } else {
        console.error('Error during Facebook login:', err)
        throw err
      }
    } finally {
      isLoading.value = false
    }
  }

  const sendTokenToBackend = async () => {
    // Send idToken to backend
    try {
      let apiEndpoint
      const loginMethodLocal = localStorage.getItem('loginMethod')

      if (loginMethodLocal === 'google') {
        apiEndpoint = `${ADMIN_BASE}/auth/login/google`
      } else if (loginMethodLocal === 'facebook') {
        apiEndpoint = `${ADMIN_BASE}/auth/login/facebook`
      } else {
        throw new Error('Unsupported login method')
      }

      const res = await axios.post(apiEndpoint, {
        idToken: idToken.value,
        email: emailFirebase.value
      })
      accessToken.value = res.data.data.accessToken
      refreshToken.value = res.data.data.refreshToken
      localStorage.setItem('token', accessToken.value)
      localStorage.setItem('refreshToken', refreshToken.value)
      const userInfo = await axios.get(`${ADMIN_BASE}/user/profile`, {
        headers: {
          Authorization: `Bearer ${accessToken.value}`
        }
      })
      user.value = userInfo.data.data
      usernameUser.value = userInfo.data.data.username
      blueBadge.value = userInfo.data.data.isBlueBadge
      channelId.value = userInfo.data.data.channelId
      localStorage.setItem('userAvatar', userInfo.data.data.avatar)
      localStorage.setItem('userInfo', userInfo.data.data.username)
      localStorage.setItem('userIsBlueBadge', userInfo.data.data.isBlueBadge)
      localStorage.setItem('userChannelId', userInfo.data.data.channelId)
      localStorage.setItem('userEmail', userInfo.data.data.email)
    } catch (error) {
      errorMsg.value = error.response?.data?.message || 'Login failed'
      console.error('Error during token submission:', error)
      await logout()
      throw error
    }
  }

  const loginWithEmail = async (values) => {
    // Login with email
    isLoading.value = true
    try {
      const res = await axios.post(`${ADMIN_BASE}/auth/login`, values)
      const data = res.data

      if (data.success) {
        accessToken.value = data.data.accessToken
        refreshToken.value = data.data.refreshToken
        const userInfo = await axios.get(`${ADMIN_BASE}/user/profile`, {
          headers: {
            Authorization: `Bearer ${accessToken.value}`
          }
        })

        user.value = userInfo.data.data
        localStorage.setItem('userInfo', userInfo.data.data.username)
        localStorage.setItem('userEmail', userInfo.data.data.email)
        localStorage.setItem('userIsBlueBadge', userInfo.data.data.isBlueBadge)
        localStorage.setItem('userChannelId', userInfo.data.data.channelId)
        localStorage.setItem('userAvatar', userInfo.data.data.avatar || defaultAvatar)
        localStorage.setItem('token', accessToken.value)
        localStorage.setItem('loginMethod', 'email')
        localStorage.setItem('refreshToken', refreshToken.value)
      }
    } catch (error) {
      if (error.response) {
        const errorRes = error.response.data
        errorMsg.value = errorRes.message
        await logout()
      }
    } finally {
      isLoading.value = false
    }
  }

  const logout = async () => {
    const loginMethod = localStorage.getItem('loginMethod')
    try {
      isLoading.value = true
      if (loginMethod === 'email') {
        const currentRefreshToken = localStorage.getItem('refreshToken')
        const config = {
          headers: {
            Authorization: `Bearer ${currentRefreshToken}`
          }
        }
        const response = await axios.get(`${ADMIN_BASE}/auth/log-out`, config)
        if (response.status === 200) {
          user.value = {}
          usernameUser.value = null
          idToken.value = null
          accessToken.value = null
          refreshToken.value = null
          localStorage.removeItem('token')
          localStorage.removeItem('refreshToken')
          localStorage.removeItem('loginMethod')
          localStorage.removeItem('userInfo')
          localStorage.removeItem('userAvatar')
          localStorage.removeItem('userEmail')
          localStorage.removeItem('userIsBlueBadge')
          localStorage.removeItem('userChannelId')
        } else throw new Error(response.error.message)
      } else {
        await signOut(auth)
        user.value = {}
        usernameUser.value = null
        idToken.value = null
        accessToken.value = null
        refreshToken.value = null
        localStorage.removeItem('token')
        localStorage.removeItem('refreshToken')
        localStorage.removeItem('loginMethod')
        localStorage.removeItem('userInfo')
        localStorage.removeItem('userAvatar')
        localStorage.removeItem('userEmail')
        localStorage.removeItem('userIsBlueBadge')
        localStorage.removeItem('userChannelId')
      }
    } catch (err) {
      errorMsg.value = err.message
    } finally {
      isLoading.value = false
    }
  }

  // Lifecycle hooks (onMounted)
  onMounted(async () => {
    // Check status login
    isLoading.value = true
    const tokenLocal = localStorage.getItem('token')
    const loginMethodLocal = localStorage.getItem('loginMethod')

    if (tokenLocal && loginMethodLocal === 'email') {
      accessToken.value = tokenLocal
      isLoading.value = false

      try {
        const userInfo = await axios.get(`${ADMIN_BASE}/user/profile`, {
          headers: {
            Authorization: `Bearer ${accessToken.value}`
          }
        })

        user.value = userInfo.data.data
        localStorage.setItem('userAvatar', userInfo.data.data.avatar || defaultAvatar)
      } catch (error) {
        console.error('Error get profile: ', error)
      }
    } else if (loginMethodLocal === 'google' || loginMethodLocal === 'facebook') {
      const unsubscribe = onAuthStateChanged(auth, async (currentUser) => {
        if (currentUser) {
          user.value = currentUser
          try {
            const response = await apiAxios.get('/user/profile')
            if (response.status === 200 && response.data.data) {
              const temp = { ...user.value, ...response.data.data }
              user.value = { ...temp }
              localStorage.setItem('userAvatar', response.data.data.avatar)
            }
          } catch (error) {
            console.error('Error getting profile: ', error)
          }
          await currentUser.getIdToken().then((idTokenFB) => {
            idToken.value = idTokenFB
            const localToken = localStorage.getItem('token')
            accessToken.value = localToken ? localToken : null
            if (loginMethodLocal === 'google') {
              localStorage.setItem('loginMethod', 'google')
            } else {
              localStorage.setItem('loginMethod', 'facebook')
            }
          })
          isLoading.value = false
        } else {
          user.value = null
          accessToken.value = null
          isLoading.value = false
        }
      })
      return () => {
        unsubscribe()
      }
    }
    isLoading.value = false
  })

  return {
    // states
    user,
    errorMsg,
    idToken,
    accessToken,
    refreshToken,
    isLoading,
    emailFirebase,
    usernameUser,
    blueBadge,
    channelId,
    // actions
    googleSignIn,
    facebookSignIn,
    sendTokenToBackend,
    logout,
    loginWithEmail
  }
})
