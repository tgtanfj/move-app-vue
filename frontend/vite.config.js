import { resolve, dirname } from 'node:path'
import { fileURLToPath } from 'node:url'

import tailwind from 'tailwindcss'
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import autoprefixer from 'autoprefixer'
import vueDevTools from 'vite-plugin-vue-devtools'
import VueI18nPlugin from '@intlify/unplugin-vue-i18n/vite'

import { alias } from './configs/paths.config'

// https://vitejs.dev/config/
export default defineConfig({
  css: {
    postcss: {
      plugins: [tailwind(), autoprefixer()]
    }
  },
  plugins: [
    vue(),
    vueDevTools(),
    VueI18nPlugin({
      include: resolve(dirname(fileURLToPath(import.meta.url)), './public/locales/**')
    })
  ],
  resolve: {
    alias
  }
})
