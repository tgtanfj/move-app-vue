import { useFetch } from '@utils/vue-query.util'

export const exampleService = {
  getPhotos: () => useFetch('https://jsonplaceholder.typicode.com/photos')
}
