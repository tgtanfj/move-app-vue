<script setup>
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@common/ui/table'
import { useRouter } from 'vue-router'
import Star from '../../assets/icons/Star.vue'
import { formatDateLong } from '../../utils/convertDate.util'
import { convertToTimeFormat } from '../../utils/formatVideoLength.util'

const props = defineProps({
  videos: {
    type: Array,
    required: true
  }
})

const router = useRouter()

const routeToInDepth = (videoId) => {
  router.push({ name: 'InDepthVideo', params: { videoId: videoId } })
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
      <TableRow
        v-for="video in videos"
        class="cursor-pointer hover:bg-[#EDFFFC]"
        @click="routeToInDepth(video.video_id)"
      >
        <TableCell class="w-40"> <img :src="video.thumbnail" class="w-[124px] h-[70px]"/> </TableCell>
        <TableCell
          ><p class="font-semibold w-[300px] truncate">
            {{ video.video_title }}
          </p>
          <p class="mb-3">{{ video.category_title }}</p>
          <p>{{ formatDateLong(video.created_at) }}</p>
        </TableCell>
        <TableCell class="text-center">{{ video.total_views }}</TableCell>
        <TableCell class="text-center">
          {{ video.avg_watch ? convertToTimeFormat(Math.round(video.avg_watch)) : 0 }}
          <span>
            ({{
              video.avg_watch
                ? Math.round((Math.round(video.avg_watch) / video.video_duration) * 100)
                : 0
            }}%)
          </span>
        </TableCell>
        <TableCell class="text-center"
          >{{ video.video_ratings }} <Star class="inline ml-1 mt-[-3px]" />
        </TableCell>
        <TableCell class="text-center">{{ video.total_reps }}</TableCell>
        <TableCell class="text-center">{{ video.total_donators }}</TableCell>
      </TableRow>
    </TableBody>
  </Table>
</template>
