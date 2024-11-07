<script setup>
import { Table, TableBody, TableHead, TableHeader, TableRow } from '@common/ui/table'
import RenderChannelComments from './RenderChannelComments.vue'

const props = defineProps({
  comments: {
    type: Array,
    required: true
  }
})

const emit = defineEmits(['updateComments', 'updateReplyCount', 'handleDeleteComment'])

const updateComments = (value) => {
  emit('updateComments', value)
}

const updateReplyCount = (id, number) => {
  emit('updateReplyCount', id, number)
}

const handleDeleteComment = (commentId) => {
  emit('handleDeleteComment', commentId)
}
</script>

<template>
  <div>
    <Table class="mt-5">
      <TableHeader>
        <TableRow class="uppercase">
          <TableHead> {{ $t('channel_comments.comments') }} </TableHead>
          <TableHead>{{ $t('channel_comments.reps') }}</TableHead>
          <TableHead>{{ $t('channel_comments.videos') }}</TableHead>
          <TableHead>{{ $t('channel_comments.actions') }}</TableHead>
        </TableRow>
      </TableHeader>
      <TableBody :disabled="true" class="w-full">
        <RenderChannelComments
          @update-comments="updateComments"
          @updateReplyCount="updateReplyCount"
          @handleDeleteComment="handleDeleteComment"
          :comments="comments"
        />
      </TableBody>
    </Table>
  </div>
</template>
