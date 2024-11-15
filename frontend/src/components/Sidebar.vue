<script setup>
import {
  ChartArea,
  ChevronDown,
  CircleDollarSign,
  MessageSquare,
  Settings,
  Video
} from 'lucide-vue-next'
import { computed, ref } from 'vue'
import { useRoute } from 'vue-router'

const sidebarList = [
  {
    name: 'Videos',
    icon: Video,
    path: '/streamer/videos'
  },
  {
    name: 'Comments',
    icon: MessageSquare,
    path: '/streamer/comments'
  },
  {
    name: 'Analytics',
    icon: ChartArea,
    path: '/streamer/analytics',
    children: [
      {
        name: 'Overview',
        path: 'overview'
      },
      {
        name: 'Video analytics',
        path: 'videos'
      }
    ]
  },
  {
    name: 'Cashout',
    icon: CircleDollarSign,
    path: '/streamer/cashout'
  },
  {
    name: 'Bio Settings',
    icon: Settings,
    path: '/streamer/bio-settings'
  }
]

const router = useRoute()
const path = computed(() => router.path)
const activeDropdown = ref(path.value.startsWith('/streamer/analytics'))
const toggleDropdown = (name) => {
  activeDropdown.value = activeDropdown.value === name ? null : name
}

const isActive = (name) => {
  return activeDropdown.value === name
}
const isActivePath = (itemPath) => {
  return (
    path.value.startsWith(itemPath) ||
    (itemPath === '/streamer/analytics/videos' && path.value.includes('/streamer/analytics/video/'))
  )
}
</script>

<template>
  <div class="mt-[56px] w-[241px] fixed left-0 z-10">
    <div className="grid h-screen flex-none w-[241px] min-h-screen">
      <div className="border-r bg-gray-100/40 lg:block">
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
                    :class="{ 'text-primary font-semibold': isActivePath(item.path) }"
                  >
                    <component :is="item.icon" class="mr-2" />
                    {{ item.name }}
                    <span
                      :class="{ '-rotate-180': isActive(item.name) }"
                      class="ml-auto transition-transform"
                    >
                      <ChevronDown />
                    </span>
                  </router-link>
                  <router-link
                    v-else
                    class="flex items-center w-full text-left p-2 rounded"
                    :to="item.path"
                    :class="{ 'text-primary font-semibold': item.path === path }"
                  >
                    <component :is="item.icon" class="mr-2" />
                    {{ item.name }}
                  </router-link>
                </div>
                <ul v-show="isActive(item.name)" class="ml-4">
                  <li v-for="child in item.children" :key="child.name">
                    <router-link
                      :to="`${item.path}/${child.path}`"
                      class="block w-full text-left p-2 pl-6 rounded"
                      :class="{ 'font-semibold': isActivePath(`${item.path}/${child.path}`) }"
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
