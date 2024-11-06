import { useToast } from '@common/ui/toast'
import { STRIPE_KEY, STRIPE_PAYMENT_METHOD_API, STRIPE_TOKEN_API } from '@constants/api.constant'
import { apiAxios } from '@helpers/axios.helper'
import { t } from '@helpers/i18n.helper'
import axios from 'axios'
import { defineStore } from 'pinia'
import { onBeforeUnmount, onMounted, ref } from 'vue'

const { toast } = useToast()

export const usePaymentStore = defineStore('payment', () => {
  const isLoading = ref(false)
  const isDeleting = ref(false)
  const isCreating = ref(false)
  const userPaymentList = ref(null)
  const showSucessNotify = ref(false)
  const stripeErr = ref('')
  const reps = ref(0)
  const isBuying = ref(false)
  const selectedPackage = ref(null)
  const repsPackageList = ref([])
  const showPurchaseModal = ref(false)

  onMounted(async () => {
    try {
      const res = await apiAxios.get('/user/profile')
      if (res.status === 200) {
        reps.value = res.data.data.numberOfREPs
      } else return
    } catch (error) {
      return
    }
  })

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
  const setSelectedPackage = (item) => {
    selectedPackage.value = item
  }

  const setShowPurchaseModal = (value) => {
    showPurchaseModal.value = value
  }

  const fetchUserPaymentMethod = async () => {
    try {
      isLoading.value = true
      const response = await apiAxios.get('/stripe/list-cards')
      if (response.status === 200 && response.data?.data?.id) {
        userPaymentList.value = { ...response.data.data }
      } else return
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
      if (response.status === 201) {
        showSucessNotify.value = true
        await fetchUserPaymentMethod()
        startNotificationTimer()
      }
    } catch (error) {
      toast({ description: error.response?.data?.message || error, variant: 'destructive' })
    }
  }
  const createToken = async (card) => {
    try {
      const response = await axios.post(
        STRIPE_TOKEN_API,
        new URLSearchParams({
          'card[number]': card.number,
          'card[exp_month]': card.exp_month,
          'card[exp_year]': card.exp_year,
          'card[cvc]': card.cvc,
          'card[name]': card.name,
          'card[address_country]': card.country
        }),
        {
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            Authorization: `Bearer ${STRIPE_KEY}`
          }
        }
      )

      if (response.status === 200) {
        if (card.type.toLowerCase() !== response.data.card.brand.toLowerCase()) {
          throw new Error('Wrong Card Type')
        } else {
          const { id: token } = response.data
          return { token }
        }
      } else {
        throw new Error('Error creating token')
      }
    } catch (error) {
      return { error: error.response?.data?.error || error.message }
    }
  }
  const createUserPaymentMethod = async (card, route, router) => {
    try {
      isCreating.value = true
      const { token, error: tokenError } = await createToken(card)
      if (tokenError) throw new Error(tokenError.message || tokenError)

      if (token) {
        const res = await axios.post(
          STRIPE_PAYMENT_METHOD_API,
          new URLSearchParams({
            type: 'card',
            'card[token]': token
          }),
          {
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
              Authorization: `Bearer ${STRIPE_KEY}`
            }
          }
        )

        if (res.status === 200) {
          const { id: paymentMethodId } = res.data
          await sendPaymentIdToServer(paymentMethodId)
          if (route && router) {
            const { query } = route
            if (query && query.source && selectedPackage.value) {
              router.push({ path: query.source, query: { redirectFrom: 'add-payment' } })
            }
          }
        } else {
          throw new Error(res.data.error || 'Error creating payment method')
        }
      } else {
        throw new Error('Token was not created')
      }
    } catch (err) {
      stripeErr.value = 'Your card number is incorrect'
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
      if (response.status === 201) {
        userPaymentList.value = null
        toast({ description: `${t('wallet.remove_success')}`, variant: 'successfully' })
      } else throw new Error(response.data)
    } catch (error) {
      toast({ description: error.response?.data?.message || error, variant: 'destructive' })
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

  const buyRepsPackageWithSavedPayment = async (paymentMethodId, item) => {
    try {
      isBuying.value = true
      const response = await apiAxios.post('/payment/buy-reps', {
        repPackageId: item.id,
        paymentMethodId: paymentMethodId
      })
      if (response.data && response.data.success) {
        reps.value += item.numberOfREPs
      } else throw new Error('Payment unsuccessful')
    } catch (error) {
      throw error
    } finally {
      isBuying.value = false
    }
  }
  const buyRepsPackageWithoutSavedPaymentMethod = async (stripe, card, item, isChecked, path) => {
    try {
      isBuying.value = true
      const { token, error: tokenError } = await createToken(card)
      if (tokenError) throw new Error(tokenError.message || tokenError)

      if (token) {
        const res = await axios.post(
          STRIPE_PAYMENT_METHOD_API,
          new URLSearchParams({
            type: 'card',
            'card[token]': token
          }),
          {
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
              Authorization: `Bearer ${STRIPE_KEY}`
            }
          }
        )
        if (res.status === 200) {
          const { id: paymentMethodId } = res.data
          const response = await apiAxios.post('/payment/buy-reps', {
            repPackageId: item.id,
            paymentMethodId: paymentMethodId,
            save: isChecked
          })
          if (response.status === 200) {
            if (isChecked) {
              await fetchUserPaymentMethod()
            }
            const { client_secret, status } = response.data.data
            if (status !== 'succeeded') {
              await stripe.value.confirmCardPayment(client_secret)
            }
            reps.value += item.numberOfREPs
            if (path && path === '/wallet') {
              await fetchUserPaymentMethod()
            }
          } else {
            throw new Error('Error purchasing. Please try again.')
          }
        } else {
          throw new Error(res.data.error || 'Error creating payment method')
        }
      } else {
        throw new Error('Token was not created')
      }
    } catch (err) {
      throw err
    } finally {
      isBuying.value = false
    }
  }

  const checkForSavedPayment = async () => {
    if (userPaymentList.value) {
      return true
    }
    try {
      const response = await apiAxios.get('/stripe/list-cards')
      if (response.status === 200 && response.data.data) {
        userPaymentList.value = { ...response.data.data }
        return true
      }
    } catch (error) {
      return false
    }

    return false
  }
  return {
    isLoading,
    isDeleting,
    isCreating,
    isBuying,
    userPaymentList,
    showSucessNotify,
    stripeErr,
    repsPackageList,
    reps,
    selectedPackage,
    showPurchaseModal,
    setShowPurchaseModal,
    setSelectedPackage,
    checkForSavedPayment,
    getListRepsPackage,
    hideNotify,
    fetchUserPaymentMethod,
    deleteUserPaymentMethod,
    createUserPaymentMethod,
    sendPaymentIdToServer,
    buyRepsPackageWithSavedPayment,
    buyRepsPackageWithoutSavedPaymentMethod
  }
})
