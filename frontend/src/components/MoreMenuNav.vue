<template>
  <DropdownMenu>
    <DropdownMenuTrigger class="flex items-center">
      <DotDotDot />
    </DropdownMenuTrigger>

    <DropdownMenuContent align="start" class="w-[194px] mt-4 px-3">
      <DropdownMenuItem
        class="flex gap-3 items-center py-2 px-1 cursor-pointer group hover:text-primary focus:bg-transparent"
      >
        <p class="font-semibold group-hover:text-primary duration-100">About us</p>
      </DropdownMenuItem>
      <DropdownMenuItem
        class="flex gap-3 items-center py-2 px-1 cursor-pointer group hover:text-primary focus:bg-transparent"
      >
        <p class="font-semibold group-hover:text-primary duration-100">FQA</p>
      </DropdownMenuItem>
      <DropdownMenuItem
        class="flex gap-3 items-center py-2 px-1 cursor-pointer group hover:text-primary focus:bg-transparent"
      >
        <p class="font-semibold group-hover:text-primary duration-100">Community guideline</p>
      </DropdownMenuItem>
      <DropdownMenuItem
        class="flex gap-3 px-1 items-center py-2 cursor-pointer group hover:text-primary focus:bg-transparent"
      >
        <p class="font-semibold group-hover:text-primary duration-100">Terms of Service</p>
      </DropdownMenuItem>
      <DropdownMenuItem
        class="flex gap-3 px-1 items-center py-2 cursor-pointer group hover:text-primary focus:bg-transparent"
      >
        <p class="font-semibold group-hover:text-primary duration-100">Private policy</p>
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
</script>
