import StreamerCashout from '@views/StreamerCashout.vue'
import StreamerListVideo from '@views/StreamerListVideo.vue'
import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: () => import('../views/UserLayout.vue'),
      children: [
        {
          path: '/',
          name: 'home-page',
          component: () => import('../views/HomeView.vue')
        },
        {
          path: '/profile',
          name: 'profile',
          component: () => import('../views/UserProfile.vue')
        },
        {
          path: '/categories',
          name: 'categories',
          component: () => import('../views/CategoriesView.vue')
        },
        {
          path: '/categories/:title',
          name: 'category-id',
          component: () => import('../components/categories/CategoryId.vue')
        },
        {
          path: '/video/:id',
          component: () => import('../views/ShowVideoDetail.vue')
        }
      ]
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
  ],
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    } else {
      return { top: 0 }
    }
  }
})

export default router
