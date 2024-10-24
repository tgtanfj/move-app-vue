<script setup>
import { ref } from 'vue'
import PaymentHistory from './PaymentHistory.vue'
import PaymentMethodTab from './PaymentMethodTab.vue'

const tabs = [
  { id: 1, label: 'payment_history.payment_method' },
  { id: 2, label: 'payment_history.payment_history' }
]

const tabShow = ref(1)

const changeTab = (tab) => {
  tabShow.value = tab
}
</script>

<template>
  <div class="w-full mt-7">
    <div
      class="ml-0 pl-0 text-[16px] w-full border-b-[1px] border-[#999999] pb-0 rounded-none mb-4 self-start flex justify-start gap-4"
    >
      <div
        v-for="tab in tabs"
        :key="tab.id"
        @click="changeTab(tab.id)"
        class="border-b-[3px] cursor-pointer px-0 mx-3 rounded-none flex items-center justify-start ml-0 pl-0 pb-3 transition-transform"
        :class="{
          'border-[#13D0B4] text-[#13D0B4] font-bold': tabShow === tab.id,
          'border-white': tabShow !== tab.id
        }"
      >
        {{ $t(tab.label) }}
      </div>
    </div>
    <div v-show="tabShow === 1">
      <PaymentMethodTab />
    </div>
    <div v-show="tabShow === 2">
      <PaymentHistory />
    </div>
  </div>
</template>
