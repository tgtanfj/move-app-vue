import { VueQueryPlugin } from '@tanstack/vue-query'

const vueQueryPluginOptions = {
  queryClientConfig: {
    defaultOptions: {
      queries: {
        refetchOnWindowFocus: false
      }
    }
  }
}

export const install = (app) => {
  app.use(VueQueryPlugin, vueQueryPluginOptions)
}
