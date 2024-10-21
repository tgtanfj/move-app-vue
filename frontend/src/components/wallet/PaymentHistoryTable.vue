<script setup>
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@common/ui/table'
import { formatDateLong, formatTime } from '../../utils/convertDate.util';

const props = defineProps({
  payments: {
    type: Array,
    required: true
  }
})
</script>
<template>
  <Table class="mt-5">
    <TableHeader>
      <TableRow class="uppercase">
        <TableHead class="w-96"> {{ $t('payment_history.date') }} </TableHead>
        <TableHead>{{ $t('payment_history.time') }}</TableHead>
        <TableHead class="text-center">{{ $t('payment_history.product_name') }}</TableHead>
      </TableRow>
    </TableHeader>
    <TableBody v-if="payments.length > 0">
      <TableRow v-for="payment in payments" :key="payment">
        <TableCell> {{ formatDateLong(payment.createdAt.split('T')[0]) }} </TableCell>
        <TableCell>{{ formatTime(payment.createdAt) }}</TableCell>
        <TableCell class="font-semibold text-center"
          >{{ payment.repsPackage.numberOfREPs }} REPs</TableCell
        >
      </TableRow>
    </TableBody>
  </Table>
</template>
