<script setup>
import { Popover, PopoverContent, PopoverTrigger } from '@common/ui/popover'
import ListRepPackage from '@components/rep/ListRepPackage.vue'
import { ChevronRight, X } from 'lucide-vue-next'
import { reactive, ref, watchEffect } from 'vue'
import { Button } from '../../common/ui/button/index'
import { PRESET_MESSAGE } from '../../constants/giftreps.constanst'
import { useDonation, useGiftPackages, useUserReps } from '../../services/giftreps.services'
import { useAuthStore } from '../../stores/auth'
import { useCommentToggleStore } from '../../stores/commentToggle.store'
import { useOpenLoginStore } from '../../stores/openLogin'
import { usePaymentStore } from '../../stores/payment'
import BaseDialog from '../BaseDialog.vue'

const props = defineProps({
  videoId: {
    type: [String, Number],
    required: true
  }
})
const isPopoverOpen = ref(false)
const isOpenBuyReps = ref(false)
const openDonationSuccess = ref(false)
const donateSuccessReps = ref(0)
const userStore = useAuthStore()
const paymentStore = usePaymentStore()
const openLoginStore = useOpenLoginStore()
const commentToggleStore = useCommentToggleStore()
const listReps = ref([])
const giftReps = reactive({
  giftPackageId: 0,
  content: PRESET_MESSAGE[0],
  videoId: props.videoId
})
const { data, isLoading } = useGiftPackages()
const { data: dataUser, isLoading: isLoadingUser } = useUserReps()
const { isPending, mutate } = useDonation()

const showListReps = ref(false)

watchEffect(() => {
  if (!isLoading.value && data.value) {
    listReps.value = data.value.data
  }
})
watchEffect(() => {
  if (!isLoadingUser.value && dataUser.value) {
    commentToggleStore.setChannelId(dataUser.value.data?.channelId)
  }
})

const handleOpenPopover = () => {
  const isLogin = !!userStore.accessToken
  isOpenBuyReps.value = false
  if (isLogin) {
    isPopoverOpen.value = true
  } else {
    openLoginStore.toggleOpenLogin()
  }
}
const closePopover = () => {
  isPopoverOpen.value = false
  giftReps.giftPackageId = 0
  giftReps.content = PRESET_MESSAGE[0]
}
const closeDialog = () => {
  openDonationSuccess.value = false
  closePopover()
}

const handleCloseModal = () => {
  showListReps.value = false
  giftReps.giftPackageId = 0
  giftReps.content = PRESET_MESSAGE[0]
}
const handleBackGiftModal = () => {
  showListReps.value = false
  isOpenBuyReps.value = false
}

const handleGetReps = () => {
  isOpenBuyReps.value = true
  showListReps.value = true
}

function handleClickMessage(value) {
  giftReps.content = value
}

function handleClickReps(value) {
  giftReps.giftPackageId = value.id
}

function getNumberOfREPs(giftPackageId) {
  const selectedPackage = listReps.value.find((item) => item.id === giftPackageId)
  return selectedPackage ? selectedPackage.numberOfREPs : 0
}

const handleDonation = () => {
  mutate(
    {
      ...giftReps
    },
    {
      onSuccess: () => {
        openDonationSuccess.value = true
        isPopoverOpen.value = false
        donateSuccessReps.value = getNumberOfREPs(giftReps.giftPackageId)
        paymentStore.reps -= donateSuccessReps.value
      }
    }
  )
}

</script>
<template>
  <Popover :open="isPopoverOpen">
    <PopoverTrigger>
      <Button @click.stop="handleOpenPopover" class="text-[14px] py-5 pl-5 pr-4"
        >{{ $t('gift_reps.gift_reps') }} <ChevronRight class="ml-2"
      /></Button>
    </PopoverTrigger>
    <PopoverContent class="p-0 w-[480px] rounded-lg border-none">
      <div v-show="!isOpenBuyReps">
        <div class="flex justify-between p-5 py-4 border-b-2 border-lightGray">
          <div>
            <h3 class="text-[16px] font-semibold mb-1">{{ $t('gift_reps.support') }}</h3>
            <p class="text-13px">{{ $t('gift_reps.select') }}</p>
          </div>
          <X @click="closePopover" class="cursor-pointer" />
        </div>
        <div class="p-3 px-4 flex justify-between gap-2">
          <div v-for="item in listReps" :key="item">
            <img
              :src="item.image"
              alt=""
              class="h-24 cursor-pointer"
              :class="{
                'bg-[#EDFFFC] rounded-xl':
                  giftReps.giftPackageId && item.id === giftReps.giftPackageId
              }"
              @click="handleClickReps(item)"
            />
          </div>
        </div>
        <div class="border-t-2 border-lightGray" v-if="giftReps.giftPackageId">
          <div class="p-5">
            <p
              v-for="(item, index) in PRESET_MESSAGE"
              :key="index"
              class="cursor-pointer p-3 mb-2 rounded-xl border border-lightGray hover:bg-[#EDFFFC] hover:border hover:border-primary"
              :class="{ 'bg-[#EDFFFC] !border-primary': item === giftReps.content }"
              @click="handleClickMessage(item)"
            >
              {{ item }}
            </p>

            <Button
              class="mt-1 text-[14px]"
              :disabled="paymentStore.reps < getNumberOfREPs(giftReps.giftPackageId) || isPending"
              :variant="
                paymentStore.reps < getNumberOfREPs(giftReps.giftPackageId) ? 'disabled' : ''
              "
              @click="handleDonation"
              :is-loading="isPending"
              >Send {{ getNumberOfREPs(giftReps.giftPackageId) }} REPs</Button
            >
          </div>
        </div>
        <div class="bg-[#008370] p-4 flex justify-between items-center text-white rounded-b-lg">
          <p
            class="text-[17px]"
            v-html="
              $t('gift_reps.have', {
                amount: `<strong>${paymentStore.reps} REPs</strong>`
              })
            "
          ></p>
          <Button @click="handleGetReps">{{ $t('gift_reps.get') }}</Button>
        </div>
      </div>
      <!--BUY REPS-->
      <ListRepPackage
        :showListReps="showListReps"
        @close-modal="handleCloseModal"
        @back-giftrep="handleBackGiftModal"
        @success-buy="closePopover"
        :isGiftReps="true"
      />
    </PopoverContent>
  </Popover>

  <BaseDialog
    v-model:open="openDonationSuccess"
    @update:open="
      (val) => {
        if (!val) closeDialog()
      }
    "
    :width="480"
  >
    <div class="text-center">
      <h3 class="font-bold my-4 text-xl">{{ $t('gift_reps.success') }}</h3>
      <p>
        {{ $t('gift_reps.success_desc', { donateSuccessReps }) }}
      </p>
    </div>
  </BaseDialog>
</template>
