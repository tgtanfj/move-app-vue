<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { t } from '@helpers/i18n.helper'
import { usePaymentStore } from '../../stores/payment'
import { loadStripe } from '@stripe/stripe-js'
import { STRIPE_KEY } from '@constants/api.constant'

import { Button } from '@common/ui/button'
import { Dialog, DialogContent, DialogHeader, DialogTitle } from '@common/ui/dialog'
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
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from '@common/ui/tooltip'

import VisaCardIcon from '@assets/icons/VisaCardIcon.vue'
import MasterCardIcon from '@assets/icons/MasterCardIcon.vue'

import { walletServices } from '@services/wallet.services'
import { walletSchema } from '../../validation/schema'
import { formatDateToDDMMMYYYY } from '@utils/wallet.util'
import { hasEmptyProperty } from '@utils/userProfile.util'
import { useForm } from 'vee-validate'
import { ChevronLeft, X } from 'lucide-vue-next'
import { useQueryClient } from '@tanstack/vue-query'

const paymentStore = usePaymentStore()
const emit = defineEmits(['buy-package', 'close-modal', 'back-giftrep', 'success-buy'])
const queryClient = useQueryClient()

const router = useRouter()

const isPaymentRequired = ref(false)
const stripe = ref(null)
const countries = ref(null)
const isLoading = ref(false)
const userCountryIso = ref(null)
const cardType = ref('')
const expDate = ref('')
const showError = ref(false)
const cardholderName = ref('')
const cvc = ref('')
const cardNumber = ref('')
const showConfirmModal = ref(false)
const showSuccessModal = ref(false)
const showFailureModal = ref(false)
const purchaseError = ref('')
const isChecked = ref(false)
const coun = ref('')
const wrongCardType = ref('')

const isSubmitEnabled = computed(() => {
  if (!isPaymentRequired.value) return true
  else {
    const isFormDataEmpty = hasEmptyProperty(values)
    return !isFormDataEmpty
  }
})

const route = useRoute()

onMounted(async () => {
  await walletServices.getCountries().then((response) => {
    if (response) countries.value = response?.data
  })
  const handleCallAPis = async () => {
    await walletServices.fetchUserLocation().then((response) => {
      if (response) coun.value = response?.country
    })
  }
  isLoading.value = true
  await handleCallAPis()
  isLoading.value = false
})

watch(
  () => paymentStore.showPurchaseModal,
  (newValue) => {
    if (newValue) {
      resetForm()
      userCountryIso.value = coun.value
      setValues({ ...values, country: coun.value })
    }
  }
)

watch(userCountryIso, (newValue) => setValues({ ...values, country: newValue }))
watch(cardType, (newValue) => {
  if (newValue) {
    setValues({ ...values, cardType: cardType.value })
  }
})
watch(cardNumber, (newValue) => {
  setValues({ ...values, cardNumber: newValue })
})
watch(cvc, (newValue) => {
  setValues({ ...values, cvc: newValue })
})
watch(cardholderName, (newValue) => {
  setValues({ ...values, cardholderName: newValue })
})
watch(expDate, (newValue) => {
  if (newValue) {
    setValues({
      ...values,
      expDate: newValue
    })
  } else {
    setValues({
      ...values,
      expDate: ''
    })
  }
})

watch(cardNumber, (newValue) => {
  if (newValue.length >= 6) {
    if (newValue.startsWith('4')) {
      cardType.value = 'visa'
      setValues({ ...values, cardType: 'visa' })
    } else if (newValue.startsWith('2') || newValue.startsWith('5')) {
      cardType.value = 'mastercard'
      setValues({ ...values, cardType: 'mastercard' })
    }
  } else {
    cardType.value = ''
    setValues({ ...values, cardType: '' })
  }
})

watch(
  () => paymentStore.showPurchaseModal,
  (newValue) => {
    if (!newValue) {
      resetFormOnClose()
    }
  }
)

onMounted(() => {
  paymentStore.getListRepsPackage()
})

onMounted(async () => {
  stripe.value = await loadStripe(STRIPE_KEY)
})

const props = defineProps({
  showListReps: {
    type: Boolean,
    required: true
  },
  isGiftReps: {
    type: Boolean,
    required: false
  }
})

const { values, setValues, errors, resetForm } = useForm({
  initialValues: {
    cardholderName: '',
    country: '',
    cardNumber: '',
    cvc: '',
    cardType: '',
    expDate: ''
  },
  validationSchema: walletSchema
})

const handelBuyRepsPackage = async (item) => {
  paymentStore.setSelectedPackage(item)
  const hasSavedPayment = await paymentStore.checkForSavedPayment()
  isPaymentRequired.value = !hasSavedPayment
  emit('buy-package', item)
  paymentStore.setShowPurchaseModal(true)
}

const handleShowConfirmModal = () => {
  if (!isPaymentRequired.value) showConfirmModal.value = true
  else {
    if (Object.keys(errors.value).length > 0) {
      return (showError.value = true)
    }
    const isAccepted = values.cardType === 'visa' || values.cardType === 'mastercard'
    if (!isAccepted) {
      return (wrongCardType.value = 'Please enter a valid Visa or credit card number only')
    }
    showConfirmModal.value = true
  }
}

const closeModal = () => {
  emit('close-modal')
}

const handleBackGiftModal = () => {
  emit('back-giftrep')
}

const handleRedirectToAddPayment = () => {
  const currentPath = route.path
  emit('close-modal')
  paymentStore.setShowPurchaseModal(false)
  router.push({ name: 'wallet', query: { source: currentPath } })
}

const resetAfterSuccess = () => {
  showConfirmModal.value = false
  paymentStore.setShowPurchaseModal(false)
  isChecked.value = false
  emit('close-modal')
  showError.value = false
  cardNumber.value = ''
  cardholderName.value = ''
  cardType.value = ''
  expDate.value = ''
  cvc.value = ''
  showSuccessModal.value = true
}

const resetAfterFailure = () => {
  showConfirmModal.value = false
  showFailureModal.value = true
}

const reset = () => {
  showConfirmModal.value = false
  paymentStore.setShowPurchaseModal(false)
  emit('close-modal')
  showSuccessModal.value = true
}

const onSubmit = async () => {
  try {
    if (!isPaymentRequired.value) {
      await paymentStore.buyRepsPackageWithSavedPayment(
        paymentStore.userPaymentList.id,
        paymentStore.selectedPackage
      )
      queryClient.invalidateQueries('payment_history')
      reset()
    } else {
      const expirationParts = values.expDate.split('/').map(Number)
      const cardData = {
        number: values.cardNumber,
        exp_month: expirationParts[0],
        exp_year: expirationParts[1],
        cvc: values.cvc,
        name: values.cardholderName,
        country: userCountryIso.value,
        type: values.cardType
      }
      await paymentStore.buyRepsPackageWithoutSavedPaymentMethod(
        stripe,
        cardData,
        paymentStore.selectedPackage,
        isChecked.value,
        route.path
      )
      resetAfterSuccess()
      queryClient.invalidateQueries('payment_history')
    }
  } catch (error) {
    purchaseError.value = error
    resetAfterFailure()
  }
}
const resetFormOnClose = () => {
  cardNumber.value = ''
  cardholderName.value = ''
  cardType.value = ''
  expDate.value = ''
  cvc.value = ''
  userCountryIso.value = ''
  showError.value = false
  isChecked.value = false
}

const handleCloseSuccessModal = () => {
  showSuccessModal.value = false
  setTimeout(() => {
    paymentStore.setSelectedPackage(null)
  }, 300)
  emit('success-buy')
}
const handleCloseFailureModal = () => {
  showFailureModal.value = false
  setTimeout(() => {
    paymentStore.setSelectedPackage(null)
  }, 300)
}

const handleTrim = (e) => {
  cardholderName.value = e.target.value.trim()
  setValues({ ...values, cardholderName: cardholderName.value.trim() })
}

const handleCheckCardNumber = (event) => {
  const input = event.target.value
  const filteredInput = input.replace(/[^0-9]/g, '').slice(0, 16)
  cardNumber.value = filteredInput
  setValues({ ...values, cardNumber: filteredInput })
}
const handleCheckCVC = (event) => {
  const input = event.target.value
  const filteredInput = input.replace(/[^0-9]/g, '').slice(0, 3)
  cvc.value = filteredInput
  setValues({ ...values, cvc: filteredInput })
}
const handleCheckCardName = (event) => {
  const input = event.target.value
  const trimmedInput = input.replace(/\s+/g, ' ').trim()
  cardholderName.value = trimmedInput
  setValues({ ...values, cardholderName: trimmedInput })
}

const handleCheckExpDate = (event) => {
  let input = event.target.value

  // Remove non-numeric characters
  input = input.replace(/\D/g, '')

  // Ensure the month is between 01 and 12
  if (input.length >= 2) {
    let month = parseInt(input.substring(0, 2), 10)
    if (month > 12) {
      month = 12
    }
    input = month.toString().padStart(2, '0') + input.substring(2)
  }

  // Add '/' after the month
  if (input.length > 2) {
    input = input.substring(0, 2) + '/' + input.substring(2)
  }

  // Limit input to 5 characters (MM/YY)
  if (input.length > 5) {
    input = input.substring(0, 5)
  }

  // Handle backspace
  if (event.inputType === 'deleteContentBackward' && input.length === 3) {
    input = input.substring(0, 2)
  }

  expDate.value = input
  setValues({ ...values, expDate: input })
}
</script>

<template>
  <div>
    <div
      class="absolute right-0 bg-white text-black border-2 shadow-lg rounded-md mt-3 min-w-[300px] z-5"
      :class="{ hidden: !showListReps }"
    >
      <div class="px-2 mt-3">
        <div class="flex items-center justify-between" v-if="isGiftReps">
          <Button variant="link" @click="handleBackGiftModal" class="text-black text-[14px] p-0"
            ><ChevronLeft class="mr-1" />Back</Button
          >
          <X class="cursor-pointer" @click="closeModal" />
        </div>
        <div class="flex items-center justify-between px-3">
          <h2 class="font-bold my-2 text-2xl font-sans">{{ t('buyreps.buy_reps') }}</h2>
          <X class="cursor-pointer" @click="closeModal" v-if="!isGiftReps" />
        </div>
        <p class="text-base font-sans px-3">
          {{ t('buyreps.you_have') }}
          <span class="font-semibold">{{ paymentStore.reps }} {{ t('buyreps.reps') }}</span>
        </p>
        <p class="text-sm text-slate-400 font-sans px-3">{{ t('buyreps.price_in_usd') }}</p>
      </div>
      <div class="w-full h-[.7px] bg-slate-200 my-2"></div>
      <ul v-if="paymentStore.repsPackageList.length > 0">
        <li v-for="(item, index) in paymentStore.repsPackageList" :key="item.id" :item="item">
          <div class="flex items-center justify-between mx-4 my-3">
            <p class="font-bold text-xl">{{ item.numberOfREPs }} {{ t('buyreps.reps') }}</p>
            <Button
              class="min-w-[100px] text-lg"
              variant="default"
              @click="handelBuyRepsPackage(item)"
              >{{ t('buyreps.us$') }} {{ item.price }}</Button
            >
          </div>
          <div
            v-if="index < paymentStore.repsPackageList.length - 1"
            class="w-full h-[.7px] bg-slate-200 my-2"
          ></div>
        </li>
      </ul>
    </div>
    <Dialog v-model:open="paymentStore.showPurchaseModal">
      <DialogContent>
        <DialogHeader>
          <DialogTitle class="text-[20px] font-bold">
            {{ t('buyreps.complete_purchase') }}
          </DialogTitle>
        </DialogHeader>
        <div>
          <h3 class="text-xl font-bold text-[#666666] my-3">{{ t('buyreps.order_summary') }}</h3>
          <div class="flex justify-between">
            <p class="font-sans font-bold text-lg">
              {{ paymentStore.selectedPackage?.numberOfREPs }} {{ t('buyreps.reps') }}
            </p>
            <p>{{ t('buyreps.us$') }}{{ paymentStore.selectedPackage?.price }}</p>
          </div>
          <div class="text-[11px]">
            {{ t('buyreps.one_time_charge') }} {{ formatDateToDDMMMYYYY(new Date(Date.now())) }}
          </div>
          <div class="w-full h-[.7px] bg-slate-200 my-2"></div>
          <div class="flex items-center justify-end gap-4">
            <p class="text-xs">{{ t('buyreps.total') }}</p>
            <p class="font-semibold">
              {{ t('buyreps.us$') }}{{ paymentStore.selectedPackage?.price }}
            </p>
          </div>
        </div>
        <h3 class="mb-3 text-xl font-bold text-[#666666]">{{ t('wallet.payment_detail') }}</h3>
        <div v-if="isPaymentRequired">
          <div>
            <form @submit.prevent="onSubmit" class="grid grid-cols-1 gap-2 w-full">
              <div class="grid grid-cols-2 w-full gap-3">
                <div class="flex flex-col items-start">
                  <FormField v-slot="{ componentField }" name="cardholderName">
                    <FormItem class="w-full">
                      <FormLabel class="!text-black">{{ t('wallet.card_holder') }}</FormLabel>
                      <FormControl>
                        <Input
                          maxlength="50"
                          placeholder="Card Holder Name"
                          class="border-[#CCCCCC] h-[40px] w-full"
                          type="text"
                          v-bind="componentField"
                          v-model.trim="cardholderName"
                          @input="handleCheckCardName"
                          @blur="handleTrim"
                        />
                      </FormControl>
                      <FormMessage :class="{ hidden: !showError }" />
                    </FormItem>
                  </FormField>
                </div>
                <div class="flex flex-col items-start">
                  <p>{{ t('user_profile.country') }}</p>
                  <Select v-model="userCountryIso">
                    <SelectTrigger class="border-[#CCCCCC] h-[40px] w-full mt-2">
                      <SelectValue v-if="isLoading" placeholder="Loading..." />
                      <SelectValue v-if="!isLoading" placeholder="Select country" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectGroup v-if="countries">
                        <SelectItem
                          v-for="country in countries"
                          :key="country?.name"
                          :value="country?.iso2"
                        >
                          {{ country?.name }}
                        </SelectItem>
                      </SelectGroup>
                    </SelectContent>
                  </Select>
                </div>
              </div>
              <div class="grid grid-cols-2 w-full gap-3">
                <div class="flex flex-col items-start">
                  <FormField v-slot="{ componentField }" name="cardNumber">
                    <FormItem class="w-full">
                      <FormLabel class="!text-black">{{ t('wallet.card_number') }}</FormLabel>
                      <FormControl>
                        <Input
                          maxlength="16"
                          placeholder="Card Number"
                          class="border-[#CCCCCC] h-[40px] w-full"
                          type="text"
                          v-bind="componentField"
                          v-model.trim="cardNumber"
                          @input="handleCheckCardNumber"
                          @focus="wrongCardType = ''"
                        />
                      </FormControl>
                      <FormMessage :class="{ hidden: !showError }" />
                    </FormItem>
                  </FormField>
                </div>
                <div class="flex flex-col items-start">
                  <FormField v-slot="{ componentField }" name="cardType">
                    <FormItem class="w-full">
                      <FormLabel class="!text-black">{{ t('wallet.card_type') }}</FormLabel>
                      <div class="flex gap-1 items-center">
                        <div
                          :class="{
                            'cursor-pointer border-2 p-2 items-center flex justify-center rounded-md': true,
                            'opacity-100': values.cardType === 'visa',
                            'opacity-30': values.cardType !== 'visa'
                          }"
                        >
                          <VisaCardIcon />
                        </div>
                        <div
                          :class="{
                            'cursor-pointer border-2 px-2 py-1 items-center flex justify-center rounded-md': true,
                            'opacity-100': values.cardType === 'mastercard',
                            'opacity-30': values.cardType !== 'mastercard'
                          }"
                        >
                          <MasterCardIcon class="w-7 h-5" />
                        </div>
                      </div>
                      <FormMessage :class="{ hidden: !showError }" />
                    </FormItem>
                  </FormField>
                </div>
              </div>
              <p class="text-red-500 text-sm" v-if="wrongCardType">{{ wrongCardType }}</p>
              <div class="grid grid-cols-2 w-full gap-3">
                <div>
                  <label>Expiration date</label>
                  <FormField v-slot="{ componentField }" name="expDate">
                    <!-- <FormItem class="w-full flex items-center gap-4 mt-2"> -->
                    <div class="w-full flex items-center gap-4 mt-2">
                      <input
                        maxlength="5"
                        placeholder="MM/YY"
                        class="flex text-[16px] mb-1 py-2 px-3 border-[1px] rounded-lg focus:border-[#13D0B4] focus:outline-none border-[#CCCCCC] h-[40px] w-[120px] !m-0 p-2"
                        v-model="expDate"
                        @input="handleCheckExpDate"
                      />
                    </div>
                    <FormMessage :class="{ hidden: !showError }" />
                  </FormField>
                </div>
                <div class="w-full gap-3">
                  <div class="flex flex-col w-full">
                    <label
                      >CVV2/CVC2
                      <TooltipProvider>
                        <Tooltip>
                          <TooltipTrigger
                            asChild
                            class="ml-2 cursor-pointer rounded-full border-[2px] py-[1px] px-[4px] border-black font-semibold"
                          >
                            <span>?</span>
                          </TooltipTrigger>
                          <TooltipContent>
                            <p class="text-[8px] max-w-[400px] whitespace-normal break-words">
                              {{ t('wallet.cvc') }}
                            </p>
                          </TooltipContent>
                        </Tooltip>
                      </TooltipProvider>
                    </label>
                    <FormField v-slot="{ componentField }" name="cvc" class="w-full">
                      <FormItem class="w-full flex flex-col mt-2">
                        <Input
                          maxlength="3"
                          class="border-[#CCCCCC] h-[40px] w-[100px]"
                          type="text"
                          v-bind="componentField"
                          v-model.trim="cvc"
                          @input="handleCheckCVC"
                        />
                      </FormItem>
                      <FormMessage :class="{ hidden: !showError }" />
                    </FormField>
                  </div>
                </div>
              </div>
            </form>
          </div>
        </div>
        <div v-else class="flex justify-between">
          <div class="flex gap-3 items-center">
            <div class="flex items-center gap-3">
              <VisaCardIcon
                v-if="paymentStore.userPaymentList?.card?.brand === 'visa'"
                class="shadow"
              />
              <MasterCardIcon
                v-if="paymentStore.userPaymentList?.card?.brand === 'mastercard'"
                class="w-10 h-8 shadow"
              />
            </div>
            <p class="flex items-center text-sm">
              <span class="capitalize text-sm">
                {{ paymentStore.userPaymentList?.card?.brand }}&nbsp;
              </span>
              ending with
              <span class="ml-2 font-bold text-lg">
                {{ paymentStore.userPaymentList?.card?.last4 }}</span
              >
            </p>
          </div>
          <div class="text-primary cursor-pointer" @click="handleRedirectToAddPayment">Change</div>
        </div>
        <p class="text-sm text-gray-400">
          {{ t('buyreps.by_submit') }}
        </p>
        <div className="flex items-center my-3 gap-3" v-if="isPaymentRequired">
          <Checkbox
            :checked="isChecked"
            @update:checked="isChecked = !isChecked"
            id="terms"
            class="w-5 h-5"
          />
          <label htmlFor="terms" className="text-xs ">
            {{ t('buyreps.save_detail') }}
          </label>
        </div>

        <div class="flex items-center justify-center gap-10">
          <p>
            {{ t('buyreps.total') }}
            <span class="font-semibold"
              >{{ t('buyreps.us$') }}{{ paymentStore.selectedPackage.price }}</span
            >
          </p>
          <Button @click="handleShowConfirmModal" type="submit" :disabled="!isSubmitEnabled">{{
            $t('button.pay')
          }}</Button>
        </div>
      </DialogContent>
    </Dialog>
    <Dialog v-model:open="showConfirmModal">
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Confirm Purchase</DialogTitle>
          <DialogDescription
            >Are you sure you want to purchase {{ paymentStore.selectedPackage.numberOfREPs }} reps
            with {{ paymentStore.selectedPackage.price }}$ ?</DialogDescription
          >
        </DialogHeader>
        <div class="flex items-center justify-center gap-4">
          <Button
            @click="showConfirmModal = false"
            :disabled="paymentStore.isBuying"
            variant="outline"
            >{{ t('button.cancel') }}</Button
          >
          <Button
            @click="onSubmit"
            :is-loading="paymentStore.isBuying"
            :disabled="paymentStore.isBuying"
            >{{ t('button.ok') }}</Button
          >
        </div>
      </DialogContent>
    </Dialog>
    <Dialog v-model:open="showSuccessModal">
      <DialogContent>
        <DialogHeader>
          <DialogTitle class="text-2xl font-bold">Order success</DialogTitle>
          <p class="text-lg font-semibold">
            You purchase of {{ paymentStore.selectedPackage.numberOfREPs }} reps is successfully
          </p>
        </DialogHeader>
        <div class="flex items-center justify-center gap-4">
          <Button @click="handleCloseSuccessModal">{{ t('button.ok') }}</Button>
        </div>
      </DialogContent>
    </Dialog>
    <Dialog v-model:open="showFailureModal">
      <DialogContent>
        <DialogHeader>
          <DialogTitle class="text-2xl font-bold">Order failed</DialogTitle>
          <p class="text-lg font-semibold">
            You purchase of {{ paymentStore.selectedPackage.numberOfREPs }} is not successfully
          </p>
          <DialogDescription>{{ purchaseError }}</DialogDescription>
        </DialogHeader>
        <div class="flex items-center justify-center gap-4">
          <Button @click="handleCloseFailureModal">{{ t('button.ok') }}</Button>
        </div>
      </DialogContent>
    </Dialog>
  </div>
</template>
