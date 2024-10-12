<script setup>
import CheckVerifyIcon from '@assets/icons/CheckVerifyIcon.vue'
import DislikeOffIcon from '@assets/icons/DislikeOffIcon.vue'
import DislikeOnIcon from '@assets/icons/DislikeOnIcon.vue'
import LikeOffIcon from '@assets/icons/LikeOffIcon.vue'
import LikeOnIcon from '@assets/icons/LikeOnIcon.vue'
import RepsSenderIcon from '@assets/icons/RepsSenderIcon.vue'
import YellowRepsIcon from '@assets/icons/YellowRepsIcon.vue'
import { convertTimeComment } from '@utils/convertTimePostVideo.util'
import { formatViews } from '@utils/formatViews.util'
import { ChevronUp } from 'lucide-vue-next'
import { ChevronDown } from 'lucide-vue-next'
import { ref, watch } from 'vue'
import defaultAvatar from '../../assets/icons/default-avatar.png'
import { commentServices } from '@services/comment.services'

const props = defineProps({
  comments: {
    type: Array,
    required: true
  }
})

const emit = defineEmits(['update-comments'])

const showRepliesIds = ref([])
const showFullContentIds = ref([])
const showFullReplyIds = ref([])
const repliesPerPage = 10
const repliesToShow = ref({})

const localComments = ref([...props.comments])

watch(
  () => props.comments,
  (newComments) => {
    localComments.value = [...newComments]
  }
)

const toggleCommentContent = (commentId) => {
  const index = showFullContentIds.value.indexOf(commentId)
  if (index > -1) {
    showFullContentIds.value.splice(index, 1)
  } else {
    showFullContentIds.value.push(commentId)
  }
}

const handleLike = async (item) => {
  try {
    if (!item.hasOwnProperty('isLike')) {
      const res = await commentServices.createCommentReaction(item?.id, true)
      if (res.message === 'success') {
        item.isLike = true
        item.numberOfLike += 1
      }
    } else if (item.isLike === false) {
      const res = await commentServices.updateCommentReaction(item?.id, true)
      if (res.message === 'success') {
        item.isLike = true
        item.numberOfLike += 1
      }
    }
    emit('update-comments', toRaw(localComments.value))
  } catch (error) {
    console.error('Error liking:', error)
  }
}

const handleUnLike = async (item) => {
  try {
    const res = await commentServices.deleteCommentReaction(item.id, false)
    if (res.message === 'success') {
      delete item.isLike
      item.numberOfLike -= 1
    }
    emit('update-comments', toRaw(localComments.value))
  } catch (error) {
    console.error('Error unliking:', error)
  }
}

const handleDislike = async (item) => {
  try {
    if (!item.hasOwnProperty('isLike')) {
      const res = await commentServices.createCommentReaction(item?.id, false)
      if (res.message === 'success') item.isLike = false
    } else if (item.isLike === true) {
      const res = await commentServices.updateCommentReaction(item?.id, false)
      if (res.message === 'success') {
        item.isLike = false
        item.numberOfLike -= 1
      }
    }
    emit('update-comments', toRaw(localComments.value))
  } catch (error) {
    console.error('Error disliking:', error)
  }
}

const handleUnDislike = async (item) => {
  try {
    const res = await commentServices.deleteCommentReaction(item.id)
    if (res.message === 'success') delete item.isLike
    emit('update-comments', toRaw(localComments.value))
  } catch (error) {
    console.error('Error undisliking:', error)
  }
}

// const toggleReplies = (commentId) => {
//   const index = showRepliesIds.value.indexOf(commentId)
//   if (index > -1) {
//     showRepliesIds.value.splice(index, 1)
//   } else {
//     showRepliesIds.value.push(commentId)
//     repliesToShow.value[commentId] = repliesPerPage
//   }
// }

// const showMoreReplies = (commentId) => {
//   if (
//     repliesToShow.value[commentId] <
//     props.comments.find((comment) => comment.id === commentId).replies.length
//   ) {
//     repliesToShow.value[commentId] += repliesPerPage
//   }
// }

// const toggleReplyContent = (replyId) => {
//   const index = showFullReplyIds.value.indexOf(replyId)
//   if (index > -1) {
//     showFullReplyIds.value.splice(index, 1)
//   } else {
//     showFullReplyIds.value.push(replyId)
//   }
// }
</script>

<template>
  <div class="w-full flex flex-col items-start gap-8">
    <div v-for="(item, index) in comments" :key="item.id">
      <div class="flex items-start gap-4">
        <img
          :src="item.user.avatar ? item.user.avatar : defaultAvatar"
          class="object-cover w-[40px] h-[40px] rounded-full"
        />
        <div class="flex flex-col gap-1">
          <RepsSenderIcon class="mb-1" v-if="item.totalDonation !== 0" />
          <div class="flex items-center gap-3">
            <p class="text-[13px] font-bold">{{ item.user.fullName }}</p>
            <CheckVerifyIcon v-if="item.user.isActive" />
            <div v-if="item.totalDonation !== 0" class="flex items-end gap-2">
              <YellowRepsIcon />
              <p class="text-[#FFB564] text-[12px] -mb-[1px]">
                Gifted {{ item.totalDonation }} REPs
              </p>
            </div>
            <p class="text-[12px] text-[#666666] -mb-[2px]">
              {{ item.createdAt ? convertTimeComment(item.createdAt) : '1 second ago' }}
            </p>
          </div>
          <div>
            <div
              class="flex flex-col items-start"
              v-if="item.content.length > 300 && !showFullContentIds.includes(item.id)"
            >
              {{ item.content.slice(0, 300) }}...
              <button @click="toggleCommentContent(item.id)" class="text-[#666666]">
                {{ $t('comment.read_more') }}
              </button>
            </div>
            <div class="flex flex-col items-start" v-else>
              {{ item.content }}
              <button
                v-if="item.content.length > 300"
                @click="toggleCommentContent(item.id)"
                class="text-[#666666]"
              >
                {{ $t('comment.show_less') }}
              </button>
            </div>
          </div>
          <div class="flex items-center gap-8 mt-1">
            <div class="flex items-center gap-3 justify-start">
              <div class="-mt-1">
                <LikeOnIcon
                  @click="handleUnLike(item)"
                  class="cursor-pointer"
                  v-if="item.isLike === true"
                />
                <LikeOffIcon
                  @click="handleLike(item)"
                  class="cursor-pointer"
                  v-if="!item.isLike === true"
                />
              </div>
              <p class="text-primary text-[13px]">
                {{ item.numberOfLike ? formatViews(item.numberOfLike) : '0' }}
              </p>
            </div>
            <div class="flex items-center gap-4 justify-start">
              <div class="-mb-[9px]">
                <DislikeOnIcon
                  @click="handleUnDislike(item)"
                  class="cursor-pointer"
                  v-if="item.isLike === false"
                />
                <DislikeOffIcon
                  @click="handleDislike(item)"
                  class="cursor-pointer"
                  v-if="!item.isLike === false"
                />
                <DislikeOffIcon
                  @click="handleDislike(item)"
                  class="cursor-pointer"
                  v-if="!item.hasOwnProperty('isLike')"
                />
              </div>
              <p class="text-primary text-[13px] cursor-pointer">{{ $t('comment.reply') }}</p>
            </div>
          </div>
          <!-- <div
            v-if="item.replies.length > 0"
            class="flex items-center gap-1 justify-start mt-1 cursor-pointer transition-all"
            @click="toggleReplies(item.id)"
          >
            <ChevronDown
              v-if="!showRepliesIds.includes(item.id)"
              class="text-primary w-[20px] transition-all"
            />
            <ChevronUp
              v-if="showRepliesIds.includes(item.id)"
              class="text-primary w-[20px] transition-all"
            />
            <p
              v-if="!showRepliesIds.includes(item.id)"
              class="text-primary text-[13px] font-semibold"
            >
            {{$t('comment.show')}} {{ item.replies.length }} {{$t('comment.replies')}}
            </p>
            <p
              v-if="showRepliesIds.includes(item.id)"
              class="text-primary text-[13px] font-semibold"
            >
            {{$t('comment.hide')}} {{ item.replies.length }} {{$t('comment.replies')}}
            </p>
          </div>
          <div v-if="showRepliesIds.includes(item.id)" class="w-full space-y-4 mt-2">
            <div
              v-for="(reply, index) in item.replies.slice(0, repliesToShow[item.id])"
              :key="index"
              class="flex gap-4 items-start"
            >
              <img :src="reply.avatar" class="object-cover w-[40px] h-[40px] rounded-full" />
              <div class="flex flex-col gap-1">
                <div class="flex items-center gap-3">
                  <p class="text-[13px] font-bold">{{ reply.name }}</p>
                  <CheckVerifyIcon />
                  <div class="flex items-end gap-2">
                    <YellowRepsIcon />
                    <p class="text-[#FFB564] text-[12px] -mb-[1px]">Gifted 25000 REPs</p>
                  </div>
                  <p class="text-[12px] text-[#666666] -mb-[2px]">
                    {{ reply.timestamp ? convertTimeComment(reply.timestamp) : '1 second ago' }}
                  </p>
                </div>
                <div>
                  <div
                    class="flex flex-col items-start"
                    v-if="reply.content.length > 300 && !showFullReplyIds.includes(reply.id)"
                  >
                    {{ reply.content.slice(0, 300) }}...
                    <button @click="toggleReplyContent(reply.id)" class="text-[#666666]">
                      {{$t('comment.read_more')}}
                    </button>
                  </div>
                  <div class="flex flex-col items-start" v-else>
                    {{ reply.content }}
                    <button
                      v-if="reply.content.length > 300"
                      @click="toggleReplyContent(reply.id)"
                      class="text-[#666666]"
                    >
                    {{$t('comment.show_less')}}
                    </button>
                  </div>
                </div>
                <div class="flex items-center gap-8 mt-1">
                  <div class="flex items-center gap-3 justify-start">
                    <div class="-mt-1">
                      <LikeOffIcon class="cursor-pointer" v-if="!reply.like" />
                      <LikeOnIcon class="cursor-pointer" v-if="reply.like" />
                    </div>
                    <p class="text-primary text-[13px]">
                      {{ reply.likes ? formatViews(reply.likes) : '0' }}
                    </p>
                  </div>
                  <div class="flex items-center gap-3 justify-start">
                    <div class="-mb-[9px]">
                      <DislikeOffIcon class="cursor-pointer" v-if="!reply.dislike" />
                      <DislikeOnIcon class="cursor-pointer" v-if="reply.dislike" />
                      <p></p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div
              v-if="item.replies.length > repliesToShow[item.id]"
              class="flex items-center gap-1 justify-start mt-1 cursor-pointer transition-all"
            >
              <div @click="showMoreReplies(item.id)" class="font-semibold flex items-center gap-2">
                <ChevronDown class="transition-all text-primary w-[20px]" />
                <div class="text-primary text-[13px] font-semibold">{{$t('comment.show_more_replies')}}</div>
              </div>
            </div>
          </div> -->
        </div>
      </div>
    </div>
  </div>
</template>
