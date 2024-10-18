<script setup>
import SeparatorCross from '@components/SeparatorCross.vue'
import { useSearchStore } from '../../stores/search'
const searchStore = useSearchStore()
const props = defineProps({
  searchQuery: {
    type: String,
    required: true
  }
})
</script>
<template>
  <div class="flex flex-col flex-grow mt-5 mr-10" :style="{ height: 'calc(100vh - 60px)' }">
    <SeparatorCross
      :title="`${$t('search.no_result')} ${searchQuery.length > 10 ? searchQuery.slice(0, 10) + '...' : searchQuery}`"
      class="mt-3"
    />
    <div class="flex items-center justify-center flex-col flex-grow">
      <h6 class="font-semibold text-lg text-center">
        {{ $t('search.no_result') }}
        {{ searchQuery ? searchQuery : searchStore.text ? searchStore.text : '' }}
      </h6>
      <p class="italic">{{ $t('search.try_another_keyword') }}</p>
    </div>
  </div>
</template>
