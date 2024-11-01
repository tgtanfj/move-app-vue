<script setup>
import { computed, onMounted, ref, watch } from 'vue'
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from '@common/ui/dialog'
import { FormControl, FormField, FormItem, FormMessage } from '@common/ui/form'
import { Input } from '@common/ui/input'
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectTrigger,
  SelectValue
} from '@common/ui/select'
import { Button } from '@common/ui/button'
import { t } from '@helpers/i18n.helper'
import { loadStripe } from '@stripe/stripe-js'
import { usePaymentStore } from '../../stores/payment'
import { walletServices } from '@services/wallet.services'
import { walletSchema } from '../../validation/schema'
import { validateCard } from '@utils/wallet.util'
import { STRIPE_KEY } from '@constants/api.constant'
import VisaCardIcon from '@assets/icons/VisaCardIcon.vue'
import MasterCardIcon from '@assets/icons/MasterCardIcon.vue'
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from '@common/ui/tooltip'
import { useForm } from 'vee-validate'
import { hasEmptyProperty } from '@utils/userProfile.util'
import { useRoute, useRouter } from 'vue-router'

const paymentStore = usePaymentStore()
const router = useRouter()
const route = useRoute()

const stripe = ref(null)
const isOpen = ref(false)
const countries = ref(null)
const isLoading = ref(false)
const userCountryIso = ref(null)
const cardType = ref('')
const expMonth = ref('')
const expYear = ref('')
const showError = ref(false)
const cardholderName = ref('')
const cvc = ref('')
const cardNumber = ref('')
const coun = ref('')

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

watch(userCountryIso, (newValue) => setValues({ ...values, country: newValue }))

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

watch(isOpen, async (newValue) => {
  if (newValue) {
    stripe.value = await loadStripe(STRIPE_KEY)
    resetForm()
    userCountryIso.value = coun.value
    setValues({ ...values, country: coun.value })
  }
})
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
watch([expMonth, expYear], (newValue) => {
  const [month, year] = newValue

  if (month && year) {
    setValues({
      ...values,
      expDate: `${month}/${year}`
    })
  } else {
    setValues({
      ...values,
      expDate: ''
    })
  }
})

const resetFormOnClose = () => {
  cardNumber.value = ''
  cardholderName.value = ''
  cardType.value = ''
  expMonth.value = ''
  expYear.value = ''
  cvc.value = ''
  userCountryIso.value = ''
  showError.value = false
}

const isSubmitEnabled = computed(() => {
  const isFormDataEmpty = hasEmptyProperty(values)

  return !isFormDataEmpty
})

const onSubmit = async () => {
  if (Object.keys(errors.value).length > 0) {
    showError.value = true
    return
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

    await paymentStore.createUserPaymentMethod(cardData).then(() => {
      const { query } = route
      if (query.source) router.push({ path: query.source, query: { redirectFrom: 'add-payment' } })
    })
  }
}

const handleTrim = (e) => {
  cardholderName.value = e.target.value.trim()
  setValues({ ...values, cardholderName: cardholderName.value.trim() })
}

const handleCheckExpMonth = (event) => {
  const input = event.target.value
  const filteredInput = input.replace(/[^0-9]/g, '')
  if (Number(filteredInput) > 12) {
    expMonth.value = 12
  } else {
    expMonth.value = filteredInput
  }
}
const handleCheckExpYear = (event) => {
  const input = event.target.value
  const filteredInput = input.replace(/[^0-9]/g, '')
  expYear.value = filteredInput
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
</script>
<template>
  <Dialog
    v-model:open="isOpen"
    @update:open="
      (val) => {
        if (!val) resetFormOnClose()
      }
    "
  >
    <DialogTrigger aschild>
      <Button>{{ t('wallet.setup_payment') }}</Button>
    </DialogTrigger>
    <DialogContent class="w-[604px]">
      <DialogHeader>
        <DialogTitle class="text-[24px] font-bold">{{ t('wallet.payment_detail') }}</DialogTitle>
      </DialogHeader>
      <div>
        <form @submit.prevent="onSubmit" class="grid grid-cols-1 gap-2 w-full">
          <div class="grid grid-cols-2 w-full gap-3">
            <div class="flex flex-col items-start">
              <FormField v-slot="{ componentField }" name="cardholderName">
                <FormItem class="w-full">
                  <FormLabel class="">{{ t('wallet.card_holder') }}</FormLabel>
                  <FormControl>
                    <Input
                      maxlength="50"
                      class="border-[#CCCCCC] h-[40px] w-full"
                      type="text"
                      v-bind="componentField"
                      v-model.trim="cardholderName"
                      @input="handleCheckCardName"
                      @blur="handleTrim"
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
                  <FormLabel class="">{{ t('wallet.card_number') }}</FormLabel>
                  <FormControl>
                    <Input
                      maxlength="16"
                      class="border-[#CCCCCC] h-[40px] w-full"
                      type="text"
                      v-bind="componentField"
                      v-model.trim="cardNumber"
                      @input="handleCheckCardNumber"
                      @input="handleCheckCardNumber"
                    />
                  </FormControl>
                  <FormMessage class="mt-2" :class="{ hidden: !showError }" />
                </FormItem>
              </FormField>
            </div>
            <div class="flex flex-col items-start">
              <FormField v-slot="{ componentField }" name="cardType">
                <FormItem class="w-full">
                  <FormLabel class="">{{ t('wallet.card_type') }}</FormLabel>
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
                  <FormMessage class="mt-2" :class="{ hidden: !showError }" />
                </FormItem>
              </FormField>
            </div>
          </div>
          <div class="grid grid-cols-2 w-full gap-3">
            <div>
              <label>Expiration date</label>
              <FormField v-slot="{ componentField }" name="expDate">
                <FormItem class="w-full flex flex-col gap-4 mt-2">
                  <div class="w-full flex items-center gap-4 mt-2">
                    <input
                      maxlength="2"
                      placeholder="MM"
                      class="flex text-[16px] mb-1 py-2 px-3 border-[1px] rounded-lg focus:border-[#13D0B4] focus:outline-none border-[#CCCCCC] h-[40px] w-[70px] !m-0 p-2"
                      type="text"
                      v-model.trim="expMonth"
                      @input="handleCheckExpMonth"
                      @input="handleCheckExpMonth"
                    />
                    <input
                      maxlength="2"
                      placeholder="YY"
                      class="flex text-[16px] mb-1 py-2 px-3 border-[1px] rounded-lg focus:border-[#13D0B4] focus:outline-none border-[#CCCCCC] h-[40px] w-[70px] !m-0 p-2"
                      type="text"
                      v-model.trim="expYear"
                      @input="handleCheckExpYear"
                      @input="handleCheckExpYear"
                    />
                  </div>
                  <FormMessage class="!mt-0" :class="{ hidden: !showError }" />
                </FormItem>
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
                        class="cursor-pointer rounded-full border-[2px] py-[0.8px] px-[4px] border-black font-semibold ml-2"
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
                      class="border-[#CCCCCC] h-[40px] w-[100px] mt-2"
                      type="text"
                      v-bind="componentField"
                      v-model.trim="cvc"
                      @input="handleCheckCVC"
                      @input="handleCheckCVC"
                    />
                  </FormItem>
                  <FormMessage class="mt-2" :class="{ hidden: !showError }" />
                </FormField>
              </div>
            </div>
          </div>
          <div>
            <div class="text-[10px] w-full mt-2">
              {{ t('wallet.by_submit') }}
              <span class="text-primary text-[12px]">{{ t('wallet.end_user_license') }}</span
              >,
              <span class="text-primary text-[12px]">{{ t('service.privacy_policy') }}</span>
              {{ t('wallet.and') }}
              <span class="text-primary text-[12px]">{{ t('wallet.refund_policy') }}</span
              >.
            </div>
            <div class="w-full flex items-center justify-center mt-2">
              <Button
                type="submit"
                class="w-[128px] h-[40px]"
                :isLoading="paymentStore.isCreating"
                :disabled="paymentStore.isCreating || !isSubmitEnabled"
              >
                {{ $t('button.submit') }}
              </Button>
            </div>
          </div>
        </form>
      </div>
    </DialogContent>
  </Dialog>
</template>
