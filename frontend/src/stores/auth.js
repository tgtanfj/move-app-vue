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

  // Actions
  const googleSignIn = async () => {
    // Login with Google
    const provider = new GoogleAuthProvider()
    provider.addScope('email')
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
      const userInfo = await axios.get(`${ADMIN_BASE}/user/profile`, {
        headers: {
          Authorization: `Bearer ${accessToken.value}`
        }
      })

      if (loginMethodLocal === 'email') {
        user.value = userInfo.data
        localStorage.setItem('userInfo', userInfo.data.data.username)
      }
      usernameUser.value = userInfo.data.data.username
      localStorage.setItem('token', accessToken.value)
      localStorage.setItem('refreshToken', refreshToken.value)
    } catch (error) {
      errorMsg.value = error.response?.data?.message || 'Error sending token to backend.'
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

        user.value = userInfo.data
        localStorage.setItem('userInfo', userInfo.data.data.username)
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
      }
    } catch (err) {
      errorMsg.value = err.message
    } finally {
      isLoading.value = false
    }
  }

  const refreshAccessToken = async () => {
    // Refresh token
    try {
      isLoading.value = true
      const currentRefreshToken = localStorage.getItem('refreshToken')

      if (!currentRefreshToken) {
        throw new Error('No refresh token available')
      }

      const response = await axios.get(`${ADMIN_BASE}/auth/refresh`, {
        headers: {
          Authorization: `Bearer ${currentRefreshToken}`
        }
      })

      accessToken.value = response.data.data.accessToken
      localStorage.setItem('token', accessToken.value)
    } catch (error) {
      console.error('Error refreshing access token:', error)
      await logout()
    } finally {
      isLoading.value = false
    }
  }

  // Lifecycle hooks (onMounted)
  onMounted(() => {
    // Check status login
    isLoading.value = true
    const tokenLocal = localStorage.getItem('token')
    const loginMethodLocal = localStorage.getItem('loginMethod')

    if (tokenLocal && loginMethodLocal === 'email') {
      accessToken.value = tokenLocal
      isLoading.value = false
    } else if (loginMethodLocal === 'google' || loginMethodLocal === 'facebook') {
      const unsubscribe = onAuthStateChanged(auth, (currentUser) => {
        if (currentUser) {
          user.value = currentUser
          currentUser.getIdToken().then((idToken) => {
            accessToken.value = idToken
            if (loginMethodLocal === 'google') {
              localStorage.setItem('loginMethod', 'google')
            } else {
              localStorage.setItem('loginMethod', 'facebook')
            }
            isLoading.value = false
          })
        } else {
          user.value = null
          accessToken.value = null
          isLoading.value = false
        }
      })
      return () => {
        unsubscribe()
      }
    } else {
      isLoading.value = false
    }
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
    // actions
    googleSignIn,
    facebookSignIn,
    sendTokenToBackend,
    logout,
    loginWithEmail,
    refreshAccessToken
  }
})
