<script setup>
import { ref } from 'vue'
import ProfileUserTab from './ProfileUserTab.vue'
// import NotificationsTab from './NotificationsTab.vue'

const tabShow = ref(1)

const changeTab = (tab) => {
  tabShow.value = tab
}
</script>

<template>
  <div class="w-full mt-2">
    <div
      class="ml-0 pl-0 text-[16px] w-full border-b-[1px] border-[#999999] pb-0 rounded-none mb-4 self-start flex justify-start gap-4"
    >
      <div
        @click="changeTab(1)"
        class="border-b-[3px] cursor-pointer px-0 mx-3 rounded-none flex items-center justify-start ml-0 pl-0 pb-3 transition-transform w-[55px]"
        :class="{
          'border-[#13D0B4] text-[#13D0B4] font-bold': tabShow === 1,
          'border-white': tabShow !== 1
        }"
      >
        Profile
      </div>
      <!-- <div
        @click="changeTab(2)"
        class="border-b-[3px] cursor-pointer px-0 mx-3 rounded-none flex items-center justify-start ml-0 pl-0 pb-3 transition-transform"
        :class="{
          'border-[#13D0B4] text-[#13D0B4] font-bold': tabShow === 2,
          'border-white': tabShow !== 2
        }"
      >
        Notifications
      </div> -->
    </div>
    <div v-show="tabShow === 1">
      <ProfileUserTab />
    </div>
    <!-- <div v-show="tabShow === 2">
      <NotificationsTab />
    </div> -->
  </div>
</template>
