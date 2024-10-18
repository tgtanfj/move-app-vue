<template>
  <DropdownMenu>
    <DropdownMenuTrigger class="flex items-center">
      <DotDotDot />
    </DropdownMenuTrigger>

    <DropdownMenuContent align="start" class="w-[194px] mt-4 px-3">
      <DropdownMenuItem
        class="flex gap-3 items-center py-2 px-1 cursor-pointer group hover:text-primary focus:bg-transparent"
        @click="router.push('/move/faq')"
      >
        <p class="font-semibold group-hover:text-primary duration-100">FAQ</p>
      </DropdownMenuItem>
    </DropdownMenuContent>
  </DropdownMenu>
</template>

<script setup>
import DotDotDot from '@assets/icons/DotDotDot.vue'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger
} from '@common/ui/dropdown-menu'
import { useRouter } from 'vue-router'

const router = useRouter()
</script>
