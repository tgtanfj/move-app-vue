<script setup>
import { Button } from '@common/ui/button'
import SeparatorCross from '@components/SeparatorCross.vue'
import UserProfileForm from '@components/UserProfileForm.vue'
</script>

<template>
  <div class="w-full pl-6 pt-8 h-full">
    <!-- TODO: ad setup email -->
    <div
      class="hidden w-full px-4 h-[64px] bg-[#FFF6E6] border-2 border-[#FFB564] rounded-lg mb-4 flex justify-between"
    >
      <p class="text-[14px] pt-3">
        Your email is not setup yet. You may not be able to receive any
        <span class="font-bold">billing information</span> or
        <span class="font-bold">announcement</span> from MOVE.
      </p>
      <Button class="my-auto"> Setup email now </Button>
    </div>
    <SeparatorCross title="Settings" />

    <UserProfileForm />
  </div>
</template>
