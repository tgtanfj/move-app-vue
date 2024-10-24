<script setup>
import { Calendar } from '@common/ui/calendar'
import { Popover, PopoverContent, PopoverTrigger } from '@common/ui/popover'
import { getLocalTimeZone } from '@internationalized/date'
import { Calendar as CalendarIcon } from 'lucide-vue-next'
import { computed, ref, watch } from 'vue'
import { Button } from '../../common/ui/button/index'
import { df, formatDateShort, toCalendarDate } from '../../utils/convertDate.util'

const emit = defineEmits(['dateRange'])

const date = new Date()
const todayDate = new Date()

date.setDate(date.getDate() - 30)
const startDate = ref(toCalendarDate(date))
const formattedStartDate = df.format(startDate.value.toDate(getLocalTimeZone()))

const endDate = ref(toCalendarDate(new Date()))
const formattedEndDate = df.format(endDate.value.toDate(getLocalTimeZone()))

const maxStartDate = computed(() => {
  return endDate.value
})

const minEndDate = computed(() => {
  return startDate.value
})

const maxEndDate = computed(() => {
  const start = startDate.value.toDate(getLocalTimeZone())
  const maxDate = new Date(start)

  // Calculate the current date and one year ago
  const today = new Date()
  const oneYearAgo = new Date(today)
  oneYearAgo.setDate(today.getDate() - 365)

  // If startDate is more than 365 days before today, set maxEndDate to startDate + 365 days
  if (start < oneYearAgo) {
    maxDate.setDate(start.getDate() + 365)
  } else {
    // Otherwise, maxEndDate is the current date
    return toCalendarDate(today)
  }

  return toCalendarDate(maxDate)
})

watch(startDate, (newStartDate) => {
  if (newStartDate) {
    const newStart = newStartDate.toDate(getLocalTimeZone())
    const oneYearAgo = new Date()
    oneYearAgo.setFullYear(todayDate.getFullYear() - 1)

    if (newStart < oneYearAgo) {
      // If startDate is selected more than 365 days before, set endDate to startDate + 365 days
      const updatedEndDate = new Date(newStart)
      updatedEndDate.setDate(newStart.getDate() + 365)
      endDate.value = toCalendarDate(updatedEndDate)
    }
  }
})

watch([endDate, startDate], () => {
  if (endDate.value && startDate.value) {
    emit(
      'dateRange',
      formatDateShort(startDate.value.toDate(getLocalTimeZone())),
      formatDateShort(endDate.value.toDate(getLocalTimeZone()))
    )
  }
})

</script>
<template>
  <div class="flex items-center gap-6">
    <p class="uppercase font-bold">{{ $t('payment_history.start_date') }}</p>
    <Popover>
      <PopoverTrigger as-child>
        <Button variant="link" class="border border-primary font-normal w-52">
          <CalendarIcon class="mr-2 h-4 w-4" />
          {{ startDate ? df.format(startDate.toDate(getLocalTimeZone())) : formattedStartDate }}
        </Button>
      </PopoverTrigger>
      <PopoverContent class="w-auto p-0">
        <Calendar v-model="startDate" initial-focus :max-value="maxStartDate" />
      </PopoverContent>
    </Popover>
  </div>
  <div class="flex items-center gap-6">
    <p class="uppercase font-bold">{{ $t('payment_history.end_date') }}</p>
    <Popover>
      <PopoverTrigger as-child>
        <Button variant="link" class="border border-primary font-normal w-52">
          <CalendarIcon class="mr-2 h-4 w-4" />
          {{ endDate ? df.format(endDate.toDate(getLocalTimeZone())) : formattedEndDate }}
        </Button>
      </PopoverTrigger>
      <PopoverContent class="w-auto p-0">
        <Calendar
          v-model="endDate"
          initial-focus
          :min-value="minEndDate"
          :max-value="maxEndDate"
        />
      </PopoverContent>
    </Popover>
  </div>
</template>
