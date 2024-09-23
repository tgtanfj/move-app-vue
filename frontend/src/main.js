import { createApp } from 'vue'
import './assets/css/index.css'

import App from './App.vue'
import router from './router'

const app = createApp(App)

app.use(router)
Object.values(import.meta.glob('@plugins/*.js', { eager: true })).forEach((i) => app.use(i))

app.mount('#app')
