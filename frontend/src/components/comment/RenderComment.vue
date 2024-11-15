<script setup>
import DislikeOffIcon from '@assets/icons/DislikeOffIcon.vue'
import DislikeOnIcon from '@assets/icons/DislikeOnIcon.vue'
import LikeOffIcon from '@assets/icons/LikeOffIcon.vue'
import LikeOnIcon from '@assets/icons/LikeOnIcon.vue'
import LikeOffDisabledIcon from '@assets/icons/LikeOffDisabledIcon.vue'
import DislikeOffDisabledIcon from '@assets/icons/DislikeOffDisabledIcon.vue'
import RepsSenderIcon from '@assets/icons/RepsSenderIcon.vue'
import { convertTimeComment } from '@utils/convertTimePostVideo.util'
import { formatViews } from '@utils/formatViews.util'
import { ChevronUp } from 'lucide-vue-next'
import { ChevronDown } from 'lucide-vue-next'
import { computed, ref, watch } from 'vue'
import defaultAvatar from '../../assets/images/default-avatar.png'
import { commentServices } from '@services/comment.services'
import { Input } from '@common/ui/input'
import { Button } from '@common/ui/button'
import { useOpenLoginStore } from '../../stores/openLogin'
import { useAuthStore } from '../../stores/auth'
import BlueBadgeIcon from '@assets/icons/BlueBadgeIcon.vue'
import { useCommentToggleStore } from '../../stores/commentToggle.store'
import RenderIconsReps from '../../components/channel-comments/RenderIconsReps.vue'
import {
  showRepliesByComment,
  isShowedReplies,
  repliesPerComment,
  hasMoreRepliesPerComment,
  cursorReplies,
  repliesCountPerComment,
  myReplyPerComment
} from '../../helpers/useReplies'
import DeleteAndCopyCommentButton from './DeleteAndCopyCommentButton.vue'

const props = defineProps({
  comments: {
    type: Array,
    required: true
  }
})

const emit = defineEmits([
  'update-comments',
  'updateReplyCount',
  'handleDeleteComment',
  'decreReplycount',
  'uploadNewReplycount'
])

const openLoginStore = useOpenLoginStore()
const authStore = useAuthStore()
const commentToggleStore = useCommentToggleStore()

const showFullContentIds = ref([])
const showFullReplyIds = ref([])
const replyData = ref(null)
const replyInputId = ref(null)
const isFocused = ref(false)
const isCancelComment = ref(false)
const deleteCount = ref(0)

const userAvatar = ref(localStorage.getItem('userAvatar'))

const localComments = ref([...props.comments])

watch(
  () => props.comments,
  (newComments) => {
    localComments.value = [...newComments]
  }
)

const increaseReplies = (id, number) => {
  emit('updateReplyCount', id, number)
}

const checkIsAuth = () => {
  if (!authStore.accessToken) {
    openLoginStore.toggleOpenLogin()
    return false
  } else {
    return true
  }
}

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
    if (!checkIsAuth()) return
    if (commentToggleStore.isDisabledActions) return
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
    if (!checkIsAuth()) return
    if (commentToggleStore.isDisabledActions) return
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
    if (!checkIsAuth()) return
    if (commentToggleStore.isDisabledActions) return
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
    if (!checkIsAuth()) return
    if (commentToggleStore.isDisabledActions) return
    const res = await commentServices.deleteCommentReaction(item.id)
    if (res.message === 'success') delete item.isLike
    emit('update-comments', toRaw(localComments.value))
  } catch (error) {
    console.error('Error undisliking:', error)
  }
}

// const showRepliesByComment = async (commentId) => {
//   const response = await commentServices.getRepliesByComment(commentId)
//   if (response.message === 'success') {
//     isShowedReplies.value[commentId] = true
//     const repliesArray = response.data
//     cursorReplies.value = repliesArray[repliesArray.length - 1].id
//     repliesPerComment.value[commentId] = repliesArray
//     hasMoreRepliesPerComment.value[commentId] = repliesArray.length >= 10
//     if (!repliesCountPerComment.value[commentId]) {
//       repliesCountPerComment.value[commentId] = repliesArray.length
//     } else {
//       repliesCountPerComment.value[commentId] += repliesArray.length
//     }
//     if (myReplyPerComment.value[commentId]) myReplyPerComment.value = {}
//   }
// }

const hideRepliesByComment = (commentId, item) => {
  if (item.numberOfReply < repliesCountPerComment.value[commentId]) {
    const numberCount = repliesCountPerComment.value[commentId] - item.numberOfReply
    increaseReplies(commentId, numberCount)
    if (deleteCount.value > 0) {
      emit(
        'uploadNewReplycount',
        commentId,
        repliesCountPerComment.value[commentId] - deleteCount.value
      )
      deleteCount.value = 0
    }
  }
  if (repliesPerComment.value[commentId] <= 10) {
    emit('uploadNewReplycount', commentId, repliesPerComment.value[commentId].length)
  }
  isShowedReplies.value[commentId] = false
  hasMoreRepliesPerComment.value[commentId] = false
  cursorReplies.value = null
  repliesPerComment.value[commentId] = {}
  repliesCountPerComment.value[commentId] = null
  myReplyPerComment.value = {}
}

const showMoreReplies = async (commentId) => {
  if (!hasMoreRepliesPerComment.value[commentId]) return

  const response = await commentServices.getRepliesByComment(commentId, cursorReplies.value)
  if (response.message === 'success') {
    const newReplies = response.data
    repliesPerComment.value[commentId].push(...newReplies)
    hasMoreRepliesPerComment.value[commentId] = newReplies.length >= 10
    cursorReplies.value = newReplies[newReplies.length - 1].id
    if (!repliesCountPerComment.value[commentId]) {
      repliesCountPerComment.value[commentId] = newReplies.length
    } else {
      repliesCountPerComment.value[commentId] += newReplies.length
    }
  }
}

const toggleReplyContent = (replyId) => {
  const index = showFullReplyIds.value.indexOf(replyId)
  if (index > -1) {
    showFullReplyIds.value.splice(index, 1)
  } else {
    showFullReplyIds.value.push(replyId)
  }
}

const showReplyInput = async (commentId) => {
  if (!checkIsAuth()) return
  if (commentToggleStore.isDisabledActions) return
  if (replyInputId.value === commentId) {
    return
  }
  replyInputId.value = commentId
  replyData.value = ''
}

const cancelComment = () => {
  isCancelComment.value = false
  replyData.value = ''
  isFocused.value = false
  replyInputId.value = null
}

const createReply = async (commentId) => {
  const response = await commentServices.postReply(replyData.value, commentId)
  if (response.message === 'success') {
    if (myReplyPerComment.value[commentId]) {
      myReplyPerComment.value[commentId] = response.data
      increaseReplies(commentId, 1)
    } else {
      if (
        repliesPerComment.value[commentId] &&
        !isEmptyObject(repliesPerComment.value[commentId])
      ) {
        increaseReplies(commentId, 1)
        repliesPerComment.value[commentId].push(response.data)
      } else {
        myReplyPerComment.value[commentId] = response.data
      }
    }
    replyData.value = ''
    isFocused.value = false
    replyInputId.value = null
    isCancelComment.value = false
    if (isShowedReplies.value[commentId]) {
      repliesCountPerComment.value[commentId] += 1
    }
  }
}

const isReplyValid = computed(() => {
  return replyData.value.trim() !== ''
})

const handleDeleteComment = async (id, name, commentId) => {
  if (name === 'comment') {
    const response = await commentServices.deleteCommentById(id)
    if (response.statusCode === 200) {
      emit('handleDeleteComment', id)
    }
  }
  if (name === 'reply') {
    const response = await commentServices.deleteCommentById(id)
    if (response.statusCode === 200) {
      repliesPerComment.value[commentId] = repliesPerComment.value[commentId].filter(
        (item) => item?.id !== id
      )
      emit('decreReplycount', commentId)
      deleteCount.value += 1
    }
  }
  if (name === 'myreply') {
    const response = await commentServices.deleteCommentById(id)
    if (response.statusCode === 200) {
      myReplyPerComment.value = {}
    }
  }
}

const handleShowReply = (commentId) => {
  if (myReplyPerComment.value[commentId]) {
    increaseReplies(commentId, 1)
    myReplyPerComment.value[commentId] = {}
  }
  showRepliesByComment(commentId)
}

const isEmptyObject = (obj) => {
  return obj && Object.keys(obj).length === 0 && obj.constructor === Object
}

const handleImageError = (event) => {
  event.target.src = defaultAvatar
}
</script>

<template>
  <div class="w-full flex flex-col items-start gap-8">
    <div class="w-full" v-for="item in comments" :key="item.id">
      <div class="flex items-start gap-2 w-full">
        <img
          @error="handleImageError"
          :src="item.user.avatar ? item.user.avatar : defaultAvatar"
          class="object-cover w-[40px] h-[40px] rounded-full"
        />
        <div class="px-3 w-full pb-2 flex items-start" :id="item.id">
          <div class="flex flex-col gap-1 w-full pr-10">
            <div class="flex items-center justify-start gap-2">
              <RepsSenderIcon class="mb-1" v-if="item.totalDonation !== null" />
              <div
                class="h-[24px] px-2 bg-[#FFB564] rounded-full mb-1"
                v-if="item?.lastContentDonate"
              >
                <span class="m-auto text-white text-[10px] font-bold">{{
                  item?.lastContentDonate
                }}</span>
              </div>
            </div>
            <div class="flex items-center gap-3">
              <p class="text-[13px] font-bold">{{ item.user.username }}</p>
              <div v-if="item.user.channel" class="flex items-center">
                <BlueBadgeIcon v-if="item.user.channel.isBlueBadge" />
              </div>
              <div v-if="item.totalDonation !== null" class="flex items-end gap-2">
                <RenderIconsReps :numberOfReps="item.totalDonation" />
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
                class="flex flex-col items-start content-container"
                v-if="item.content.length > 300 && !showFullContentIds.includes(item.id)"
              >
                {{ item.content.slice(0, 300) }}...
                <button @click="toggleCommentContent(item.id)" class="text-[#666666]">
                  {{ $t('comment.read_more') }}
                </button>
              </div>
              <div class="flex flex-col items-start content-container" v-else>
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
                <div v-if="!commentToggleStore.isDisabledActions" class="-mt-1">
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
                <div v-else class="-mt-1">
                  <LikeOffDisabledIcon />
                </div>
                <p v-if="!commentToggleStore.isDisabledActions" class="text-primary text-[13px]">
                  {{ item.numberOfLike ? formatViews(item.numberOfLike) : '0' }}
                </p>
                <p v-else class="text-[#A9A9A9] text-[13px]">
                  {{ item.numberOfLike ? formatViews(item.numberOfLike) : '0' }}
                </p>
              </div>
              <div class="flex items-center gap-4 justify-start">
                <div v-if="!commentToggleStore.isDisabledActions" class="-mb-[9px]">
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
                <div v-else class="-mb-[9px]">
                  <DislikeOffDisabledIcon />
                </div>
                <p
                  v-if="!commentToggleStore.isDisabledActions"
                  @click="showReplyInput(item.id)"
                  class="text-primary text-[13px] cursor-pointer"
                >
                  {{ $t('comment.reply') }}
                </p>
                <p v-else class="text-[#A9A9A9]">
                  {{ $t('comment.reply') }}
                </p>
              </div>
            </div>

            <div v-if="replyInputId === item.id" class="w-full flex items-center gap-4 mt-2">
              <img
                @error="handleImageError"
                :src="userAvatar ?? defaultAvatar"
                class="w-[40px] h-[40px] rounded-full object-cover"
              />
              <Input
                v-model="replyData"
                @focus="isFocused = true"
                @keydown.enter="createReply(item.id)"
                @keydown.esc="cancelComment"
                placeholder="Reply comment"
                class="w-full outline-none rounded-none border-t-0 border-r-0 border-l-0 border-b-2 border-[#e2e2e2] py-5 px-0 placeholder:text-[13px] placeholder:text-[#666666]"
              />
            </div>
            <div
              v-if="isFocused && replyInputId === item.id"
              class="flex items-center justify-end gap-4"
            >
              <Button @click="cancelComment" class="text-[16px] font-normal" variant="outline">{{
                $t('comment.cancel')
              }}</Button>
              <Button
                @click="createReply(item.id)"
                :disabled="!isReplyValid"
                class="w-[104px] text-[16px]"
                :class="{ 'bg-[#999999]': !isReplyValid }"
                >{{ $t('comment.send') }}</Button
              >
            </div>

            <div v-if="item.numberOfReply > 0" class="mt-1 cursor-pointer transition-all">
              <div
                @click="handleShowReply(item?.id)"
                class="flex items-center gap-1 justify-start"
                v-if="!isShowedReplies[item.id]"
              >
                <ChevronDown class="text-primary w-[20px] transition-all" />
                <p v-if="item.numberOfReply === 1" class="text-primary text-[13px] font-semibold">
                  {{ $t('comment.show') }}
                  {{ item.numberOfReply }}
                  {{ $t('comment.reply1') }}
                </p>
                <p v-else class="text-primary text-[13px] font-semibold">
                  {{ $t('comment.show') }}
                  {{ item.numberOfReply }}
                  {{ $t('comment.replies') }}
                </p>
              </div>
              <div
                @click="hideRepliesByComment(item.id, item)"
                v-if="isShowedReplies[item.id]"
                class="flex items-center gap-1 justify-start"
              >
                <ChevronUp class="text-primary w-[20px] transition-all" />
                <p v-if="item?.numberOfReply > 1" class="text-primary text-[13px] font-semibold">
                  {{ $t('comment.hide') }} {{ item?.numberOfReply }}
                  {{ $t('comment.replies') }}
                </p>
                <p v-else class="text-primary text-[13px] font-semibold">
                  {{ $t('comment.hide') }} {{ item?.numberOfReply }}
                  {{ $t('comment.reply') }}
                </p>
              </div>
            </div>

            <div v-if="myReplyPerComment[item.id]" class="w-full space-y-4 mt-2">
              <div class="flex gap-4 items-start relative">
                <img
                  @error="handleImageError"
                  :src="myReplyPerComment[item.id].user.avatar"
                  class="object-cover w-[40px] h-[40px] rounded-full"
                />
                <div class="flex flex-col gap-1">
                  <div class="flex items-center justify-start gap-2">
                    <RepsSenderIcon
                      class="mb-1"
                      v-if="myReplyPerComment[item.id]?.totalDonation !== null"
                    />
                    <div
                      class="h-[24px] px-2 bg-[#FFB564] rounded-full mb-1"
                      v-if="myReplyPerComment[item.id]?.lastContentDonate"
                    >
                      <span class="m-auto text-white text-[10px] font-bold">{{
                        myReplyPerComment[item.id]?.lastContentDonate
                      }}</span>
                    </div>
                  </div>
                  <div class="flex items-center gap-3">
                    <p class="text-[13px] font-bold">
                      {{ myReplyPerComment[item.id].user.username }}
                    </p>
                    <div v-if="myReplyPerComment[item.id].user.channel" class="flex items-center">
                      <BlueBadgeIcon v-if="myReplyPerComment[item.id].user.channel.isBlueBadge" />
                    </div>
                    <div
                      v-if="myReplyPerComment[item.id].totalDonation !== null"
                      class="flex items-end gap-2"
                    >
                      <RenderIconsReps :numberOfReps="myReplyPerComment[item.id].totalDonation" />
                      <p class="text-[#FFB564] text-[12px] -mb-[1px]">
                        Gifted {{ myReplyPerComment[item.id].totalDonation }} REPs
                      </p>
                    </div>
                    <p class="text-[12px] text-[#666666] -mb-[2px]">
                      {{
                        myReplyPerComment[item.id].createdAt
                          ? convertTimeComment(myReplyPerComment[item.id].createdAt)
                          : '1 second ago'
                      }}
                    </p>
                  </div>
                  <div>
                    <div
                      class="flex flex-col items-start content-container"
                      v-if="
                        myReplyPerComment[item.id].content.length > 300 &&
                        !showFullReplyIds.includes(myReplyPerComment[item.id].id)
                      "
                    >
                      {{ myReplyPerComment[item.id].content.slice(0, 300) }}...
                      <button
                        @click="toggleReplyContent(myReplyPerComment[item.id].id)"
                        class="text-[#666666]"
                      >
                        {{ $t('comment.read_more') }}
                      </button>
                    </div>
                    <div class="flex flex-col items-start content-container" v-else>
                      {{ myReplyPerComment[item.id].content }}
                      <button
                        v-if="myReplyPerComment[item.id].content.length > 300"
                        @click="toggleReplyContent(myReplyPerComment[item.id].id)"
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
                          @click="handleUnLike(myReplyPerComment[item.id])"
                          class="cursor-pointer"
                          v-if="myReplyPerComment[item.id].isLike === true"
                        />
                        <LikeOffIcon
                          @click="handleLike(myReplyPerComment[item.id])"
                          class="cursor-pointer"
                          v-if="!myReplyPerComment[item.id].isLike === true"
                        />
                      </div>
                      <p class="text-primary text-[13px]">
                        {{
                          myReplyPerComment[item.id].numberOfLike
                            ? formatViews(myReplyPerComment[item.id].numberOfLike)
                            : '0'
                        }}
                      </p>
                    </div>
                    <div class="flex items-center gap-4 justify-start">
                      <div class="-mb-[9px]">
                        <DislikeOnIcon
                          @click="handleUnDislike(myReplyPerComment[item.id])"
                          class="cursor-pointer"
                          v-if="myReplyPerComment[item.id].isLike === false"
                        />
                        <DislikeOffIcon
                          @click="handleDislike(myReplyPerComment[item.id])"
                          class="cursor-pointer"
                          v-if="!myReplyPerComment[item.id].isLike === false"
                        />
                        <DislikeOffIcon
                          @click="handleDislike(myReplyPerComment[item.id])"
                          class="cursor-pointer"
                          v-if="!myReplyPerComment[item.id].hasOwnProperty('isLike')"
                        />
                      </div>
                      <p></p>
                    </div>
                  </div>
                </div>
                <div class="absolute top-0 -right-[58px]">
                  <DeleteAndCopyCommentButton
                    :comment="myReplyPerComment[item.id]"
                    @handleDeleteComment="
                      handleDeleteComment(myReplyPerComment[item.id]?.id, 'myreply')
                    "
                  />
                </div>
              </div>
            </div>

            <div v-if="repliesPerComment[item.id]" class="w-full space-y-4 mt-2">
              <div
                v-for="reply in repliesPerComment[item.id]"
                :key="reply.id"
                :id="reply.id"
                class="flex gap-4 items-start py-2 relative"
              >
                <img
                  @error="handleImageError"
                  :src="reply.user.avatar"
                  class="object-cover w-[40px] h-[40px] rounded-full"
                />
                <div class="flex flex-col gap-1 justify-between w-full">
                  <div class="flex items-center justify-start gap-2">
                    <RepsSenderIcon class="mb-1" v-if="reply?.totalDonation !== null" />
                    <div
                      class="h-[24px] px-2 bg-[#FFB564] rounded-full mb-1"
                      v-if="reply?.lastContentDonate"
                    >
                      <span class="m-auto text-white text-[10px] font-bold">{{
                        reply?.lastContentDonate
                      }}</span>
                    </div>
                  </div>
                  <div class="flex items-center gap-3">
                    <p class="text-[13px] font-bold">{{ reply.user.username }}</p>
                    <div v-if="reply.user.channel" class="flex items-center">
                      <BlueBadgeIcon v-if="reply.user.channel.isBlueBadge" />
                    </div>
                    <div v-if="reply.totalDonation !== null" class="flex items-end gap-2">
                      <RenderIconsReps :numberOfReps="reply?.totalDonation" />
                      <p class="text-[#FFB564] text-[12px] -mb-[1px]">
                        Gifted {{ reply.totalDonation }} REPs
                      </p>
                    </div>
                    <p class="text-[12px] text-[#666666] -mb-[2px]">
                      {{ reply.createdAt ? convertTimeComment(reply.createdAt) : '1 second ago' }}
                    </p>
                  </div>
                  <div>
                    <div
                      class="flex flex-col items-start content-container"
                      v-if="reply.content.length > 300 && !showFullReplyIds.includes(reply.id)"
                    >
                      {{ reply.content.slice(0, 300) }}...
                      <button @click="toggleReplyContent(reply.id)" class="text-[#666666]">
                        {{ $t('comment.read_more') }}
                      </button>
                    </div>
                    <div class="flex flex-col items-start content-container" v-else>
                      {{ reply.content }}
                      <button
                        v-if="reply.content.length > 300"
                        @click="toggleReplyContent(reply.id)"
                        class="text-[#666666]"
                      >
                        {{ $t('comment.show_less') }}
                      </button>
                    </div>
                  </div>
                  <div class="flex items-center gap-8 mt-1">
                    <div class="flex items-center gap-3 justify-start">
                      <div v-if="!commentToggleStore.isDisabledActions" class="-mt-1">
                        <LikeOnIcon
                          @click="handleUnLike(reply)"
                          class="cursor-pointer"
                          v-if="reply.isLike === true"
                        />
                        <LikeOffIcon
                          @click="handleLike(reply)"
                          class="cursor-pointer"
                          v-if="!reply.isLike === true"
                        />
                      </div>
                      <div v-else class="-mt-1">
                        <LikeOffDisabledIcon />
                      </div>
                      <p
                        v-if="!commentToggleStore.isDisabledActions"
                        class="text-primary text-[13px]"
                      >
                        {{ reply.numberOfLike ? formatViews(reply.numberOfLike) : '0' }}
                      </p>
                      <p v-else class="text-[#A9A9A9] text-[13px]">
                        {{ reply.numberOfLike ? formatViews(reply.numberOfLike) : '0' }}
                      </p>
                    </div>
                    <div class="flex items-center gap-4 justify-start">
                      <div v-if="!commentToggleStore.isDisabledActions" class="-mb-[9px]">
                        <DislikeOnIcon
                          @click="handleUnDislike(reply)"
                          class="cursor-pointer"
                          v-if="reply.isLike === false"
                        />
                        <DislikeOffIcon
                          @click="handleDislike(reply)"
                          class="cursor-pointer"
                          v-if="!reply.isLike === false"
                        />
                        <DislikeOffIcon
                          @click="handleDislike(reply)"
                          class="cursor-pointer"
                          v-if="!reply.hasOwnProperty('isLike')"
                        />
                      </div>
                      <div v-else class="-mb-[9px]">
                        <DislikeOffDisabledIcon />
                      </div>
                      <p></p>
                    </div>
                  </div>
                </div>
                <div class="absolute top-2 -right-[58px]">
                  <DeleteAndCopyCommentButton
                    :comment="reply"
                    @handleDeleteComment="handleDeleteComment(reply?.id, 'reply', item?.id)"
                  />
                </div>
              </div>
              <div
                v-if="hasMoreRepliesPerComment[item.id]"
                class="flex items-center gap-1 justify-start mt-1 cursor-pointer transition-all"
              >
                <div
                  @click="showMoreReplies(item.id)"
                  class="font-semibold flex items-center gap-2"
                >
                  <ChevronDown class="transition-all text-primary w-[20px]" />
                  <div class="text-primary text-[13px] font-semibold">
                    {{ $t('comment.show_more_replies') }}
                  </div>
                </div>
              </div>
            </div>
          </div>
          <DeleteAndCopyCommentButton
            :comment="item"
            @handleDeleteComment="handleDeleteComment(item?.id, 'comment')"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.highlight {
  background-color: #f7f7f7;
  border: 2px solid #13d0b4;
  border-radius: 10px;
}

.content-container {
  word-break: break-all;
  overflow-wrap: break-word;
}
</style>
