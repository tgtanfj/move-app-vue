import { resolve, dirname } from 'path'
import { fileURLToPath } from 'url'

export const alias = {
  '@': resolve(dirname(fileURLToPath(import.meta.url)), '../src'),
  '@assets': resolve(dirname(fileURLToPath(import.meta.url)), '../src/assets'),
  '@common': resolve(dirname(fileURLToPath(import.meta.url)), '../src/common'),
  '@components': resolve(dirname(fileURLToPath(import.meta.url)), '../src/components'),
  '@constants': resolve(dirname(fileURLToPath(import.meta.url)), '../src/constants'),
  '@helpers': resolve(dirname(fileURLToPath(import.meta.url)), '../src/helpers'),
  '@layouts': resolve(dirname(fileURLToPath(import.meta.url)), '../src/layouts'),
  '@middlewares': resolve(dirname(fileURLToPath(import.meta.url)), '../src/middlewares'),
  '@plugins': resolve(dirname(fileURLToPath(import.meta.url)), '../src/plugins'),
  '@services': resolve(dirname(fileURLToPath(import.meta.url)), '../src/services'),
  '@utils': resolve(dirname(fileURLToPath(import.meta.url)), '../src/utils'),
  '@views': resolve(dirname(fileURLToPath(import.meta.url)), '../src/views')
}
