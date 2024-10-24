<script setup>
import { ref } from 'vue'
import { Button } from '@common/ui/button'
import BaseDialog from '@components/BaseDialog.vue'
import { t } from '@helpers/i18n.helper'
import { useToast } from '@common/ui/toast'
import { usePaymentStore } from '../../stores/payment'

import MasterCardIcon from '@assets/icons/MasterCardIcon.vue'
import VisaCardIcon from '@assets/icons/VisaCardIcon.vue'

const paymentStore = usePaymentStore()

const props = defineProps({
  item: {
    type: Object,
    required: true
  }
})
const { toast } = useToast()

const isOpen = ref(false)

const onDeleteItem = (id) => {
  paymentStore.deleteUserPaymentMethod(id).then(() => {
    isOpen.value = false
    toast({ description: `${t('wallet.remove_success')}`, variant: 'successfully' })
  })
}
</script>
<template>
  <div class="flex flex-col gap-2 border-1 shadow-lg p-4 min-w-[450px] rounded-lg">
    <div class="flex justify-between items-start">
      <div class="text-sm">{{ t('wallet.card_holder') }}</div>
      <div class="flex gap-4">
        <span class="text-base text-red-500 cursor-pointer" @click="isOpen = true">{{
          t('button.remove')
        }}</span>
      </div>
    </div>
    <p class="font-semibold text-xl">{{ item.name }}</p>
    <p class="text-sm">{{ t('wallet.card_number') }}</p>
    <div class="flex justify-start gap-8 items-center">
      <div class="flex items-center gap-3">
        <VisaCardIcon v-if="item.card.brand === 'visa'" class="shadow" />
        <MasterCardIcon v-if="item.card.brand === 'mastercard'" class="w-10 h-8 shadow" />
      </div>
      <p class="flex items-center">
        <span class="font-normal text-xl">**** **** ****</span>
        <span class="ml-2 font-bold text-lg">{{ item.card.last4 }}</span>
      </p>
    </div>
    <BaseDialog
      :title="$t('wallet.remove_card')"
      :description="$t('wallet.remove_card_description')"
      v-model:open="isOpen"
    >
      <div class="flex justify-end items-center gap-3">
        <Button @click="isOpen = false" variant="outline">{{ $t('button.cancel') }}</Button>
        <Button
          @click="() => onDeleteItem(item.id)"
          :disabled="paymentStore.isDeleting"
          :isLoading="paymentStore.isDeleting"
        >
          {{ $t('button.remove') }}
        </Button>
      </div>
    </BaseDialog>
  </div>
</template>
