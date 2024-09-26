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
      path: '/resetpassword/:token',
      name: 'reset-password',
      component: () => import('../views/ResetPasswordView.vue')
    }
  ]
})

export default router
