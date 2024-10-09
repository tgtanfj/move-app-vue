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
import { ref } from 'vue'

const props = defineProps({
  comments: {
    type: Array,
    required: true
  }
})

const showRepliesIds = ref([])
const showFullContentIds = ref([])
const showFullReplyIds = ref([])
const repliesPerPage = 10
const repliesToShow = ref({})

const toggleReplies = (commentId) => {
  const index = showRepliesIds.value.indexOf(commentId)
  if (index > -1) {
    showRepliesIds.value.splice(index, 1)
  } else {
    showRepliesIds.value.push(commentId)
    repliesToShow.value[commentId] = repliesPerPage
  }
}

const showMoreReplies = (commentId) => {
  if (
    repliesToShow.value[commentId] <
    props.comments.find((comment) => comment.id === commentId).replies.length
  ) {
    repliesToShow.value[commentId] += repliesPerPage
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

const toggleReplyContent = (replyId) => {
  const index = showFullReplyIds.value.indexOf(replyId)
  if (index > -1) {
    showFullReplyIds.value.splice(index, 1)
  } else {
    showFullReplyIds.value.push(replyId)
  }
}
</script>

<template>
  <div class="w-full flex flex-col items-start gap-8">
    <div v-for="(item, index) in comments" :key="index">
      <div class="flex items-start gap-4">
        <img :src="item.avatar" class="object-cover w-[40px] h-[40px] rounded-full" />
        <div class="flex flex-col gap-1">
          <RepsSenderIcon class="mb-1" />
          <div class="flex items-center gap-3">
            <p class="text-[13px] font-bold">{{ item.name }}</p>
            <CheckVerifyIcon />
            <div class="flex items-end gap-2">
              <YellowRepsIcon />
              <p class="text-[#FFB564] text-[12px] -mb-[1px]">Gifted 25000 REPs</p>
            </div>
            <p class="text-[12px] text-[#666666] -mb-[2px]">
              {{ item.timestamp ? convertTimeComment(item.timestamp) : '1 second ago' }}
            </p>
          </div>
          <div>
            <div
              class="flex flex-col items-start"
              v-if="item.content.length > 300 && !showFullContentIds.includes(item.id)"
            >
              {{ item.content.slice(0, 300) }}...
              <button @click="toggleCommentContent(item.id)" class="text-[#666666]">
                {{$t('comment.read_more')}}
              </button>
            </div>
            <div class="flex flex-col items-start" v-else>
              {{ item.content }}
              <button
                v-if="item.content.length > 300"
                @click="toggleCommentContent(item.id)"
                class="text-[#666666]"
              >
              {{$t('comment.show_less')}}
              </button>
            </div>
          </div>
          <div class="flex items-center gap-8 mt-1">
            <div class="flex items-center gap-3 justify-start">
              <div class="-mt-1">
                <LikeOffIcon class="cursor-pointer" v-if="!item.like" />
                <LikeOnIcon class="cursor-pointer" v-if="item.like" />
              </div>
              <p class="text-primary text-[13px]">
                {{ item.likes ? formatViews(item.likes) : '0' }}
              </p>
            </div>
            <div class="flex items-center gap-4 justify-start">
              <div class="-mb-[9px]">
                <DislikeOffIcon class="cursor-pointer" v-if="!item.dislike" />
                <DislikeOnIcon class="cursor-pointer" v-if="item.dislike" />
              </div>
              <p class="text-primary text-[13px] cursor-pointer">{{$t('comment.reply')}}</p>
            </div>
          </div>
          <div
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
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
