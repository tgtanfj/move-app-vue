<script setup>
import { usePaymentStore } from '../../stores/payment'
import { onMounted, ref, watch } from 'vue'
import { t } from '@helpers/i18n.helper'
import { Button } from '@common/ui/button'
import { useAuthStore } from '../../stores/auth'
import { useOpenLoginStore } from '../../stores/openLogin'
import ListRepPackage from './ListRepPackage.vue'
import { useRoute } from 'vue-router'
import { walletServices } from '@services/wallet.services'

const route = useRoute()

const props = defineProps({
  isInStreamerPage: {
    type: Boolean,
    required: true
  }
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

watch(route, (newValue) => {
  if (newValue.query.redirectFrom === 'add-payment' && paymentStore.selectedPackage) {
    setTimeout(() => {
      paymentStore.setShowPurchaseModal(true)
    }, 500)
  } else paymentStore.setShowPurchaseModal(false)
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
