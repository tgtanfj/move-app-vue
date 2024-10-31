<script setup>
import CustomSelection from '@components/channel-view/CustomSelection.vue'
import { ChevronLeft, ChevronRight } from 'lucide-vue-next'
import { onMounted, ref, watch } from 'vue'
import { Button } from '../../common/ui/button/index'
import { RESPONSE_BY_COMMENTS, SORT_COMMENTS } from '../../constants/view-channel.constant'
import CommentsTableAnalytics from './CommentsTableAnalytics.vue'
import { commentServices } from '@services/comment.services'
import LoadingTable from '@components/LoadingTable.vue'

const comments = ref([])
const isLoading = ref(false)
const meta = ref(null)
const filter = ref('all')
const sort = ref('createdAt')
const page = ref(1)

onMounted(async () => {
  await getChannelCommentsFunction()
})

const getChannelCommentsFunction = async () => {
  isLoading.value = true
  comments.value = []
  const res = await commentServices.getChannelComments(filter.value, sort.value, page.value)
  if (res.message === 'success') {
    comments.value.push(...res.data)
    meta.value = res?.meta
  }
  isLoading.value = false
}

const updateComments = (value) => {
  comments.value = value
}

const updateReplyCount = (id, number) => {
  const targetComment = comments.value.find((c) => c.id === id)
  if (targetComment) {
    targetComment.numberOfReply = targetComment.numberOfReply + number
  }
}

const handleUpdateResponses = (value) => {
  filter.value = value
  page.value = 1
}

const handleUpdateSort = (value) => {
  sort.value = value
  page.value = 1
}

const handleNextPage = () => {
  if (page.value >= meta.value?.totalPages) return
  page.value += 1
}

const handlePrevPage = () => {
  if (page.value <= 1) return
  page.value -= 1
}

watch([filter, sort, page], async () => {
  await getChannelCommentsFunction()
})
</script>

<template>
  <div class="mt-[80px] ml-6 mb-16 w-full">
    <div
      v-if="comments.length === 0 && isLoading === false"
      class="flex flex-col items-start gap-2 justify-between"
    >
      <h1 class="text-title-size font-bold">{{ $t('channel_comments.comments') }}</h1>
      <p class="text-[16px] italic">No comments found.</p>
    </div>

    <div v-else class="flex items-center justify-between pr-16 mb-5">
      <h1 class="text-title-size font-bold">{{ $t('channel_comments.comments') }}</h1>
      <div class="flex gap-10">
        <CustomSelection
          label="responses"
          :listItems="RESPONSE_BY_COMMENTS"
          @update:value="handleUpdateResponses"
        />
        <CustomSelection
          label="sort by"
          :listItems="SORT_COMMENTS"
          @update:value="handleUpdateSort"
        />
      </div>
    </div>
    <CommentsTableAnalytics
      v-if="comments.length > 0"
      :comments="comments"
      @updateComments="updateComments"
      @updateReplyCount="updateReplyCount"
    />
    <div v-if="isLoading" class="w-full flex items-center justify-center my-[300px]">
      <LoadingTable />
    </div>
    <div class="flex items-center justify-between mt-5 pr-16">
      <div class="flex items-center"></div>

      <div class="flex items-center gap-2" v-if="comments.length > 0">
        <p>
          {{
            $t('common.display_range_record', {
              to: meta?.itemFrom,
              from: meta?.itemTo,
              total: meta?.totalPages
            })
          }}
        </p>

        <div>
          <Button @click="handlePrevPage" variant="link" class="p-4">
            <ChevronLeft
              :size="16"
              :class="{
                'text-darkGray': page <= 1
              }"
            />
          </Button>
          <Button @click="handleNextPage" variant="link" class="p-4">
            <ChevronRight
              :size="16"
              :class="{
                'text-darkGray': page >= meta?.totalPages
              }"
            />
          </Button>
        </div>
      </div>
    </div>
  </div>
</template>
