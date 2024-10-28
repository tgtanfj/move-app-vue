<script setup>
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@common/ui/table'
import Star from '../../assets/icons/Star.vue'
import { truncateText } from '../../utils/truncateText.util';
import { useRouter } from 'vue-router';

const props = defineProps({
  videos: {
    type: Array,
    required: true
  }
})

const router = useRouter()

const routeToInDepth = (videoId) => {
  router.push({ name: 'InDepthVideo', params: {videoId: videoId}})
}

</script>
<template>
  <Table class="mt-5" v-if="videos.length > 0">
    <TableHeader>
      <TableRow class="uppercase">
        <TableHead> {{ $t('streamer_analysis.videos') }} </TableHead>
        <TableHead>{{ $t('streamer_analysis.details') }}</TableHead>
        <TableHead class="text-center">{{ $t('streamer_analysis.views') }}</TableHead>
        <TableHead class="text-center">{{ $t('streamer_analysis.avg_view_time') }}</TableHead>
        <TableHead class="text-center">{{ $t('streamer_analysis.ratings') }}</TableHead>
        <TableHead class="text-center">{{ $t('streamer_analysis.reps') }}</TableHead>
        <TableHead class="text-center">{{ $t('streamer_analysis.viewer_gifted') }}</TableHead>
      </TableRow>
    </TableHeader>
    <TableBody>
      <TableRow v-for="video in videos" class="cursor-pointer hover:bg-[#EDFFFC]" @click="routeToInDepth(video.id)">
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
