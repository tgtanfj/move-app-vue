<script setup>
import { usePaymentStore } from '../../stores/payment'
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { t } from '@helpers/i18n.helper'
import { X } from 'lucide-vue-next'
import { Button } from '@common/ui/button'
import { Dialog, DialogContent, DialogHeader, DialogTitle } from '@common/ui/dialog'
import { useForm } from 'vee-validate'
import { walletSchema } from '../../validation/schema'
import { loadStripe } from '@stripe/stripe-js'
import { FormControl, FormField, FormItem, FormLabel, FormMessage } from '@common/ui/form'
import { Input } from '@common/ui/input'
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectTrigger,
  SelectValue
} from '@common/ui/select'
import { Checkbox } from '@common/ui/checkbox'
import { walletServices } from '@services/wallet.services'
import { formatDateToDDMMMYYYY, validateCard } from '@utils/wallet.util'
import { useAuthStore } from '../../stores/auth'
import { useOpenLoginStore } from '../../stores/openLogin'
import { STRIPE_KEY } from '@constants/api.constant'
import VisaCardIcon from '@assets/icons/VisaCardIcon.vue'
import MasterCardIcon from '@assets/icons/MasterCardIcon.vue'
import ListRepPackage from './ListRepPackage.vue'

const props = defineProps({
  isInStreamerPage: {
    type: Boolean,
    required: true
  }
})
const { values, errors } = useForm({
  initialValues: {
    cardholderName: ''
  },
  validationSchema: walletSchema
})
const paymentStore = usePaymentStore()
const authStore = useAuthStore()
const openLoginStore = useOpenLoginStore()

const countries = ref([])
const isLoading = ref(false)
const userCountryIso = ref(null)

const showListReps = ref(false)
const modalRef = ref(null)

const onUpdateOpen = () => {
  if (authStore && authStore.accessToken) {
    showListReps.value = true
  } else {
    openLoginStore.toggleOpenLogin()
  }
}

const handleCloseModal = () => {
  showListReps.value = false
}

onMounted(async () => {
  isLoading.value = true
  try {
    const locationResponse = await walletServices.fetchUserLocation()
    userCountryIso.value = locationResponse?.country

    const countriesResponse = await walletServices.getCountries()
    countries.value = countriesResponse?.data || []
  } catch (error) {
    console.error('Error fetching user location or countries:', error)
  } finally {
    isLoading.value = false
  }
})

onBeforeUnmount(() => {
  window.removeEventListener('click', handleCloseModal)
})
</script>
<template>
  <div class="relative" ref="modalRef">
    <div class="cursor-pointer font-semibold text-xl">
      <Button v-if="paymentStore.reps > 0" @click="onUpdateOpen"
        >{{ paymentStore.reps }} {{ t('buyreps.reps') }}</Button
      >
      <p v-else class="font-semibold text-xl cursor-pointer" @click="onUpdateOpen">
        {{ t('buyreps.get_reps') }}
      </p>
    </div>
    <ListRepPackage :showListReps="showListReps" @close-modal="handleCloseModal" />
  </div>
</template>
