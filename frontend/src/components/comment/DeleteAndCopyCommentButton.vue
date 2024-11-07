<script setup>
import { useToast } from '@common/ui/toast'
import { useCommentToggleStore } from '../../stores/commentToggle.store'
import { Copy, EllipsisVertical, MessageSquareMore, Trash2 } from 'lucide-vue-next'
import { ref } from 'vue'
import { Popover, PopoverContent, PopoverTrigger } from '@common/ui/popover'

const props = defineProps({
  comment: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['handleDeleteComment'])

const commentToggleStore = useCommentToggleStore()

const { toast } = useToast()

const isCopied = ref(false)

const handleClickCopy = () => {
  if (props.comment?.content) {
    const textToCopy = props.comment?.content
    navigator.clipboard
      .writeText(textToCopy)
      .then(() => {
        isCopied.value = true

        setTimeout(() => {
          isCopied.value = false
        }, 2000)
      })
      .catch((err) => {
        toast({ description: 'Copy comment failed', variant: 'destructive' })
        console.error('Error: ', err)
      })
  }
}

const handleDeleteComment = (value) => {
  emit('handleDeleteComment', value)
}
</script>

<template>
  <Popover>
    <PopoverTrigger>
      <EllipsisVertical class="text-primary" />
    </PopoverTrigger>
    <PopoverContent align="center" class="p-0 overflow-visible w-[102px]">
      <div class="relative flex flex-col px-3">
        <div
          v-if="commentToggleStore?.userId === comment?.user?.id"
          @click="handleDeleteComment(comment?.id)"
          class="group gap-3 flex items-center cursor-pointer h-[40px]"
        >
          <Trash2 class="group-hover:text-primary" stroke-width="1.4" size="18" />
          <span class="group-hover:text-primary">{{ $t('comment.delete') }}</span>
        </div>
        <div @click="handleClickCopy" class="group gap-3 flex items-center cursor-pointer h-[40px]">
          <Copy class="group-hover:text-primary" stroke-width="1.4" size="18" />
          <span class="group-hover:text-primary">{{ $t('comment.copy') }}</span>
        </div>
        <div
          v-if="isCopied"
          class="absolute left-0 -top-[45px] p-1 border-[1.5px] rounded-lg bg-white shadow-lg z-2 w-[170px]"
        >
          <div class="p-1 flex items-center text-[14px] gap-2 font-semibold">
            <MessageSquareMore class="w-[16px] h-[24px] text-primary" />
            {{ $t('streamer.message_copied') }}
          </div>
        </div>
      </div>
    </PopoverContent>
  </Popover>
</template>
