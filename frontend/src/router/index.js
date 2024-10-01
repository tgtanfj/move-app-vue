import StreamerCashout from '@views/StreamerCashout.vue'
import StreamerListVideo from '@views/StreamerListVideo.vue'
import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: () => import('../views/HomeView.vue')
    },
    {
      path: '/reset-password/:token',
      name: 'reset-password',
      component: () => import('../views/ResetPasswordView.vue')
    },
    {
      path: '/streamer',
      component: () => import('../views/StreamerLayout.vue'),
      children: [
        {
          path: 'videos',
          component: StreamerListVideo
        },
        {
          path: 'cashout',
          component: StreamerCashout
        }
      ]
    },
    {
      path: '/profile',
      name: 'profile',
      component: () => import('../views/UserProfile.vue')
    }
  ]
})

export default router
