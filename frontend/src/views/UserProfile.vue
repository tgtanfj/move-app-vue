<script setup>
import { Button } from '@common/ui/button'
import SeparatorCross from '@components/SeparatorCross.vue'
import UserProfileForm from '@components/user-profile/UserProfileForm.vue'
</script>

<template>
  <div class="w-[90%] pl-6 pt-8 h-full">
    <SeparatorCross title="Settings" />
    <UserProfileForm />
  </div>
</template>
