<script setup>
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@common/ui/table'
import Star from '../../assets/icons/Star.vue'
import { truncateText } from '../../utils/truncateText.util';

const props = defineProps({
  videos: {
    type: Array,
    required: true
  }
})
</script>
<template>
  <Table class="mt-5" v-if="videos.length > 0">
    <TableHeader>
      <TableRow class="uppercase">
        <TableHead> {{ $t('channel_comments.comments') }} </TableHead>
        <TableHead class="text-center">{{ $t('channel_comments.reps') }}</TableHead>
        <TableHead class="text-center">{{ $t('channel_comments.videos') }}</TableHead>
      </TableRow>
    </TableHeader>
    <TableBody>
      <TableRow v-for="video in videos" class="cursor-pointer hover:bg-[#EDFFFC]">
        <TableCell class="w-40"> <img :src="video.image" /> </TableCell>
        <TableCell
          ><p class="font-semibold">
            {{ truncateText(video.details.title, 20) }}
          </p>
          <p class="mb-4">{{ video.details.category }}</p>
          <p>{{ video.details.time }}</p></TableCell
        >
        <TableCell class="text-center">{{ video.views }}</TableCell>
        <TableCell class="text-center">{{ video.average_view_time }}</TableCell>
        <TableCell class="text-center"
          >{{ video.ratings }} <Star class="inline ml-3 mt-[-3px]" />
        </TableCell>
        <TableCell class="text-center">{{ video.reps }}</TableCell>
        <TableCell class="text-center">{{ video.viewer_gifted }}</TableCell>
      </TableRow>
    </TableBody>
  </Table>
</template>
