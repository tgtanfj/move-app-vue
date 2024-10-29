<script setup>
import BellIcon from '@assets/icons/BellIcon.vue'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger
} from '@common/ui/dropdown-menu'
import { X } from 'lucide-vue-next'
import NotifyItem from '@components/notificataion/NotifyItem.vue'
import { database, ref as firebaseRef } from '@services/firebaseConfig'
import { onMounted, onUnmounted, ref } from 'vue'
import { onValue, update } from 'firebase/database'
import Loading from '@components/Loading.vue'
import { jwtDecode } from 'jwt-decode'

const isOpenModalNotify = ref(false)
const notifyList = ref([])
const isLoading = ref(false)
const badgeStatus = ref(true)
const displayCount = ref(20)
const unsubscribe = ref(null)

const getUserIdFromToken = () => {
  const token = localStorage.getItem('token')
  if (token) {
    const decodedToken = jwtDecode(token)
    return decodedToken.sub
  }
  return null
}

const fetchNotifications = async () => {
  isLoading.value = true
  const userId = getUserIdFromToken()
  if (userId) {
    const dbRef = firebaseRef(database, `notifications/${userId}`)

    unsubscribe.value = onValue(
      dbRef,
      (snapshot) => {
        if (snapshot.exists()) {
          const notificationsData = snapshot.val()
          notifyList.value = Object.entries(notificationsData).map(([id, notify]) => ({
            id,
            userId,
            ...notify
          }))

          notifyList.value.reverse()
          badgeStatus.value = notifyList.value.some((notify) => !notify.isRead)
        } else {
          console.log('No notifications available')
          notifyList.value = []
          badgeStatus.value = false
        }
        isLoading.value = false
      },
      (error) => {
        console.error('Error fetching notifications:', error)
        isLoading.value = false
      }
    )
  } else {
    console.error('User ID not found in token')
    isLoading.value = false
  }
}

const markAsRead = async (notificationId, userId) => {
  const notificationRef = firebaseRef(database, `notifications/${userId}/${notificationId}`)
  try {
    await update(notificationRef, { isRead: true })
    console.log('Notification marked as read.')
    await fetchNotifications()
  } catch (error) {
    console.error('Error marking notification as read:', error)
  }
}

const handleModalPopup = () => {
  isOpenModalNotify.value = false
}

const toggleDropdown = () => {
  fetchNotifications()
  isOpenModalNotify.value = !isOpenModalNotify.value
  badgeStatus.value = false
}

const loadMoreNotifications = () => {
  displayCount.value += 20
}

const handleScrollLoadMoreNotify = (event) => {
  const { scrollTop, clientHeight, scrollHeight } = event.target
  if (scrollTop + clientHeight >= scrollHeight - 5) {
    loadMoreNotifications()
  }
}

onMounted(() => {
  fetchNotifications()
})

onUnmounted(() => {
  if (unsubscribe.value) {
    unsubscribe.value()
  }
})
</script>

<template>
  <DropdownMenu v-model:open="isOpenModalNotify" @close="isOpenModalNotify = false">
    <DropdownMenuTrigger @click="toggleDropdown">
      <div class="relative">
        <BellIcon />
        <div
          v-if="badgeStatus"
          class="absolute top-0 right-0 w-[10px] h-[10px] bg-red-500 rounded-full"
        ></div>
      </div>
    </DropdownMenuTrigger>

    <DropdownMenuContent align="end" class="bg-black border-none mt-4 p-0 w-[340px] text-white">
      <div class="flex w-full justify-between items-center p-3 border-b-[1px] border-white">
        <div class="w-[18px]"></div>
        <h2 class="font-semibold text-lg">Notifications</h2>
        <div>
          <DropdownMenuItem class="cursor-pointer focus:bg-transparent p-0">
            <X width="18px" class="hover:text-white text-white font-bold text-right p-0" />
          </DropdownMenuItem>
        </div>
      </div>

      <div v-if="isLoading" class="py-10">
        <Loading />
      </div>

      <div
        v-else
        class="max-h-[340px] overflow-y-auto custom-scrollbar"
        @scroll="handleScrollLoadMoreNotify"
      >
        <NotifyItem
          v-if="notifyList.length > 0"
          :modalPopup="handleModalPopup"
          v-for="(notify, index) in notifyList.slice(0, displayCount)"
          :key="notify.id"
          :notifyData="notify"
          :markAsRead="markAsRead"
          :isLast="index === notifyList.length - 1"
        />

        <div v-else class="h-[300px] flex items-center justify-center">
          <p class="text-center opacity-85">
            Your notifications will be displayed here. <br />
            Follow your favorite channels to receive notifications about new videos.
          </p>
        </div>
      </div>
    </DropdownMenuContent>
  </DropdownMenu>
</template>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  width: 6px;
}

.custom-scrollbar::-webkit-scrollbar-thumb {
  background-color: #cfcfcf;
  border-radius: 8px;
}

.custom-scrollbar::-webkit-scrollbar-thumb:hover {
  background-color: #d3d3d3;
}

.custom-scrollbar::-webkit-scrollbar-track {
  background-color: #000000;
}
</style>
