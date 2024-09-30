<template>
  <div>
    <div className="grid h-screen flex-none w-[241px] min-h-screen">
      <div className="hidden border-r bg-gray-100/40 lg:block">
        <div className="flex h-full max-h-screen flex-col gap-2">
          <nav className="h-full mt-4 grid items-start px-4">
            <ul>
              <li v-for="item in sidebarList" :key="item.name" class="mb-2">
                <div>
                  <router-link
                    v-if="item.children"
                    @click.native.prevent="toggleDropdown(item.name)"
                    class="flex items-center w-full text-left p-2 rounded"
                    :to="item.children"
                  >
                    <component :is="item.icon" class="mr-2" />
                    {{ item.name }}
                    <span
                      :class="{ '-rotate-90': isActive(item.name) }"
                      class="ml-auto transition-transform"
                    >
                      <ChevronDown />
                    </span>
                  </router-link>
                  <router-link
                    v-else
                    class="flex items-center w-full text-left p-2 rounded"
                    :to="getRoute(item.name)"
                    :class="{ 'text-primary font-semibold': getRoute(item.name) === path }"
                  >
                    <component :is="item.icon" class="mr-2" />
                    {{ item.name }}
                  </router-link>
                </div>
                <ul v-show="isActive(item.name)" class="ml-4">
                  <li v-for="child in item.children" :key="child.name">
                    <router-link
                      :to="getChildRoute(item.name, child.name)"
                      class="block w-full text-left p-2 rounded"
                    >
                      {{ child.name }}
                    </router-link>
                  </li>
                </ul>
              </li>
            </ul>
          </nav>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import {
  ChartArea,
  ChevronDown,
  CircleDollarSign,
  Cookie,
  House,
  MessageSquare,
  Settings,
  Video
} from 'lucide-vue-next'
import { computed, ref } from 'vue'
import { useRoute } from 'vue-router'

const sidebarList = [
  {
    name: 'Home',
    icon: House
  },
  {
    name: 'Videos',
    icon: Video
  },
  {
    name: 'Comments',
    icon: MessageSquare
  },
  {
    name: 'Analytics',
    icon: ChartArea,
    children: [
      {
        name: 'Overview'
      },
      {
        name: 'Video analytics'
      },
      {
        name: 'Live analytics'
      }
    ]
  },
  {
    name: 'Resources',
    icon: Cookie
  },
  {
    name: 'Cashout',
    icon: CircleDollarSign
  },
  {
    name: 'Channel Settings',
    icon: Settings
  }
]
const activeDropdown = ref(null)

const toggleDropdown = (name) => {
  activeDropdown.value = activeDropdown.value === name ? null : name
}
const getRoute = (name) => {
  switch (name) {
    case 'Home':
      return '/'
    case 'Videos':
      return '/streamer/videos'
    case 'Comments':
      return '/streamer/comments'
    case 'Resources':
      return '/streamer/resources'
    case 'Cashout':
      return '/streamer/cashout'
    case 'Channel Settings':
      return '/streamer/setting'
    default:
      return '/'
  }
}
const getChildRoute = (parent, child) => {
  if (parent === 'Analytics') {
    switch (child) {
      case 'Overview':
        return '/streamer/analytics/overview'
      case 'Video analytics':
        return '/streamer/analytics/video'
      case 'Live analytics':
        return '/streamer/analytics/live'
    }
  }
}
const isActive = (name) => {
  return activeDropdown.value === name
}

const router = useRoute()
const path = computed(() => router.path)
</script>
