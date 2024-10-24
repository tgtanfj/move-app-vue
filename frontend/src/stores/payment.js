import { apiAxios } from '@helpers/axios.helper'
import { defineStore } from 'pinia'
import { onBeforeUnmount, ref } from 'vue'

export const usePaymentStore = defineStore('payment', () => {
  const isLoading = ref(false)
  const isDeleting = ref(false)
  const isCreating = ref(false)
  const userPaymentList = ref([])
  const showSucessNotify = ref(false)
  const stripeErr = ref('')

  const repsPackageList = ref([])

  onBeforeUnmount(() => {
    clearTimeout(notificationTimeout)
  })

  let notificationTimeout = null

  const hideNotify = () => {
    showSucessNotify.value = false
    clearTimeout(notificationTimeout)
  }
  const startNotificationTimer = () => {
    notificationTimeout = setTimeout(() => {
      hideNotify()
    }, 5000)
  }

  const fetchUserPaymentMethod = async () => {
    try {
      isLoading.value = true
      const response = await apiAxios.get('/stripe/list-cards')
      if (response.status === 200) {
        userPaymentList.value = response.data.data
      } else throw new Error(response.data.error)
    } catch (error) {
      console.error('Error fetching user payment:', error)
    } finally {
      isLoading.value = false
    }
  }
  const sendPaymentIdToServer = async (paymentId) => {
    try {
      const response = await apiAxios.post('/stripe/attach-card', {
        paymentMethodId: paymentId
      })
      if (response.status === 200) {
        showSucessNotify.value = true
        await fetchUserPaymentMethod()
        startNotificationTimer()
      }
    } catch (error) {
      console.error(error)
    }
  }
  const createUserPaymentMethod = async (stripe, card, billing_details) => {
    try {
      isCreating.value = true
      const { error, paymentMethod } = await stripe.createPaymentMethod({
        type: 'card',
        card,
        billing_details
      })
      if (error) {
        throw new Error(error.message)
      } else {
        if (paymentMethod.id) {
          sendPaymentIdToServer(paymentMethod.id)
        }
      }
    } catch (err) {
      stripeErr.value = err
    } finally {
      isCreating.value = false
    }
  }
  const deleteUserPaymentMethod = async (id) => {
    try {
      isDeleting.value = true
      const response = await apiAxios.post('/stripe/detach-card', {
        paymentMethodId: id
      })
      if (response.status === 200) {
        userPaymentList.value = userPaymentList.value.filter((item) => item.id !== id)
      } else throw new Error(response.data)
    } catch (error) {
      console.error('Error deleting payment method', error)
    } finally {
      isDeleting.value = false
    }
  }

  const getListRepsPackage = async () => {
    try {
      const response = await apiAxios.get('/payment/list-reps-package')
      if (response.status === 200) {
        repsPackageList.value = [...response.data.data]
      }
    } catch (error) {
      console.error('Error while loading rep packages list', error)
    }
  }
  return {
    isLoading,
    isDeleting,
    isCreating,
    userPaymentList,
    showSucessNotify,
    stripeErr,
    repsPackageList,
    getListRepsPackage,
    hideNotify,
    fetchUserPaymentMethod,
    deleteUserPaymentMethod,
    createUserPaymentMethod,
    sendPaymentIdToServer
  }
})
