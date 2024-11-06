<script setup>
import { Button } from '@common/ui/button'
import { Input } from '@common/ui/input'
import { computed, ref } from 'vue'
import { Dialog, DialogContent, DialogTrigger } from '@common/ui/dialog'
import { commentServices } from '@services/comment.services'
import defaultAvatar from '../../assets/images/default-avatar.png'
import { useAuthStore } from '../../stores/auth'
import { useOpenLoginStore } from '../../stores/openLogin'

const props = defineProps({
  videoId: {
    type: String,
    required: true
  },
  comments: {
    type: Array,
    required: true
  }
})

const emit = defineEmits(['update'])

const authStore = useAuthStore()
const openLoginStore = useOpenLoginStore()

const isCancelComment = ref(false)
const isFocused = ref(false)
const comment = ref('')
const userAvatar = localStorage.getItem('userAvatar')

const isCommentValid = computed(() => {
  return comment.value.trim() !== ''
})

const handleBlur = () => {
  if (!comment.value) {
    isFocused.value = false
  }
}

const cancelComment = () => {
  isCancelComment.value = false
  comment.value = ''
  isFocused.value = false
}

const handleCloseEsc = (event) => {
  event.preventDefault()
  isCancelComment.value = true
}

const postCommentVideo = async () => {
  if (!isCommentValid.value) return
  if (!authStore.accessToken) {
    openLoginStore.toggleOpenLogin()
  } else {
    if (!comment.value) return
    const data = await commentServices.postComment(comment.value, props.videoId)
    if (data.message === 'success') {
      emit('update', data?.data)
      comment.value = ''
      cancelComment()
    } else {
      return
    }
  }
}

const handleClickNo = () => {
  isCancelComment.value = false
}

const handleFocus = () => {
  isFocused.value = true
}

const handleClickInput = () => {
  if (!authStore.accessToken) {
    openLoginStore.toggleOpenLogin()
    isFocused.value = false
    handleBlur()
  }
}
</script>

<template>
  <div class="w-full flex flex-col items-end gap-4">
    <div class="w-full flex items-center gap-4">
      <img
        :src="authStore.user.avatar || userAvatar || defaultAvatar"
        class="w-[40px] h-[40px] rounded-full object-cover"
      />
      <Input
        v-model="comment"
        @click="handleClickInput"
        @focus="handleFocus"
        @keydown.enter="postCommentVideo"
        @keydown.esc="handleCloseEsc"
        @blur="handleBlur"
        placeholder="Write a comment"
        class="outline-none rounded-none border-t-0 border-r-0 border-l-0 border-b-2 border-[#e2e2e2] py-5 px-0 placeholder:text-[13px] placeholder:text-[#666666]"
      />
    </div>
    <div v-if="isFocused" class="flex items-center justify-end gap-4">
      <Dialog v-model:open="isCancelComment">
        <DialogTrigger aschild>
          <Button class="text-[16px] font-normal" variant="outline">{{
            $t('comment.cancel')
          }}</Button>
        </DialogTrigger>
        <DialogContent class="w-[400px] p-4">
          <p class="text-2xl font-bold">{{ $t('comment.cancel_reservation') }}</p>
          <p>{{ $t('comment.are_you_sure') }}</p>
          <div class="w-full flex items-center justify-center gap-4 mt-4">
            <Button @click="handleClickNo" class="w-24 font-normal" variant="outline">{{
              $t('comment.no')
            }}</Button>
            <Button @click="cancelComment" class="w-24">{{ $t('comment.yes') }}</Button>
          </div>
        </DialogContent>
      </Dialog>
      <Button
        @click="postCommentVideo"
        :disabled="!isCommentValid"
        class="w-[104px] text-[16px]"
        :class="{ 'bg-[#999999]': !isCommentValid }"
        >{{ $t('comment.send') }}</Button
      >
    </div>
  </div>
</template>
