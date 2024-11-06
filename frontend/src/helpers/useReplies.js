
import { commentServices } from '@services/comment.services'
import { ref } from 'vue'

const isShowedReplies = ref({})
const cursorReplies = ref(null)
const hasMoreRepliesPerComment = ref({})
const repliesPerComment = ref({})
const repliesCountPerComment = ref({})
const myReplyPerComment = ref({})

export const showRepliesByComment = async (commentId) => {
    const response = await commentServices.getRepliesByComment(commentId)
    if (response.message === 'success') {
        isShowedReplies.value[commentId] = true
        const repliesArray = response.data
        cursorReplies.value = repliesArray[repliesArray.length - 1].id
        repliesPerComment.value[commentId] = repliesArray
        hasMoreRepliesPerComment.value[commentId] = repliesArray.length >= 10
        if (!repliesCountPerComment.value[commentId]) {
            repliesCountPerComment.value[commentId] = repliesArray.length
        } else {
            repliesCountPerComment.value[commentId] += repliesArray.length
        }
        if (myReplyPerComment.value[commentId]) myReplyPerComment.value = {}
    }
}

export {
    isShowedReplies,
    repliesPerComment,
    hasMoreRepliesPerComment,
    cursorReplies,
    repliesCountPerComment,
    myReplyPerComment
}