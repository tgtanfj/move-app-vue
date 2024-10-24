<script setup>
import { computed, onMounted, ref, watch } from 'vue'
import { useForm } from 'vee-validate'
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

const paymentStore = usePaymentStore()

const { values, errors } = useForm({
  initialValues: {
    cardholderName: ''
  },
  validationSchema: walletSchema
})

const stripePublicToken = import.meta.env.VITE_PUBLIC_STRIPE_PUBLISHABLE_KEY
const stripe = ref(null)
const card = ref(null)
const cardError = ref('')
const isCardValid = ref(false)
const isOpen = ref(false)
const countries = ref(null)
const isLoading = ref(false)
const userCountryIso = ref(null)

onMounted(async () => {
  const handleCallAPis = async () => {
    await walletServices.fetchUserLocation().then((response) => {
      if (response) userCountryIso.value = response?.country
    })
    await walletServices.getCountries().then((response) => {
      if (response) countries.value = response?.data
    })
  }
  isLoading.value = true
  await handleCallAPis()
  isLoading.value = false
})

watch(isOpen, async (newValue) => {
  if (newValue) {
    stripe.value = await loadStripe(stripePublicToken)
    const elements = stripe.value.elements()
    const style = {
      base: {
        color: '#32325d',
        fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
        fontSize: '16px',
        fontSmoothing: 'antialiased',
        fontWeight: '400',
        lineHeight: '24px',
        '::placeholder': {
          color: '#aab7c4'
        }
      },
      invalid: {
        color: '#fa755a',
        iconColor: '#fa755a'
      }
    }
    card.value = await elements.create('card', { style })
    card.value.on('change', (event) => {
      if (event.error) {
        cardError.value = event.error.message
        isCardValid.value = false
      } else if (event.empty) {
        cardError.value = ''
        isCardValid.value = false
      } else {
        cardError.value = ''
        isCardValid.value = event.complete
      }
    })
    card.value.mount('#card-element')
  }
})

const isSubmitEnabled = computed(() => {
  const hasFormErrors = Object.keys(errors.value).length > 0
  const hasCardError = !!cardError.value

  return !hasFormErrors && !hasCardError && isCardValid.value
})

const onSubmit = async () => {
  if (
    Object.keys(errors.value).length > 0 ||
    cardError.value ||
    !(await validateCard(card, stripe, cardError))
  ) {
    return
  } else {
    paymentStore
      .createUserPaymentMethod(stripe.value, card.value, {
        name: values.cardholderName || 'default name',
        address: {
          country: userCountryIso.value || 'US'
        }
      })
      .then(() => {
        isOpen.value = false
      })
  }
}
</script>
<template>
  <Dialog v-model:open="isOpen">
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
                      minlength="2"
                      placeholder="Card Holder Name"
                      class="border-[#CCCCCC] h-[40px] w-full"
                      :class="{ 'border-red-500': errors.cardholderName }"
                      type="text"
                      v-bind="componentField"
                      v-model.trim="values.cardholderName"
                    />
                  </FormControl>
                  <FormMessage />
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
          <div class="col-span-2 w-full">
            <div class="flex flex-col items-start gap-1 mb-1">
              <p>{{ t('wallet.card_info') }}</p>
            </div>
            <div id="card-element"></div>
            <p class="text-sm text-red-500 mt-2" v-if="cardError">{{ cardError }}</p>
          </div>

          <div>
            <div class="text-[12px] text-[#777777] w-full mt-2">
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
                :disabled="!isSubmitEnabled || paymentStore.isCreating"
                :isLoading="paymentStore.isCreating"
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
