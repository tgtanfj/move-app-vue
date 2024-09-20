import { compile } from 'path-to-regexp'

// import { AuthService } from '@services';

export const getDefaultOptions = (queryOptions) => ({
  //TODO: this code will be implement when we have refresh token currently the system will logout when token expired
  // retry: (count, error) => {
  //   const { status } = error;

  //   if (status.code == 401) {
  //     return new Promise((resolve) => {
  //       AuthService.postRefreshToken().then(() => {
  //         resolve(true);
  //       });
  //     });
  //   }

  //   return false;
  // },

  ...queryOptions
})

export const pathToUrl = (path, params = {}) => {
  try {
    return compile(path)(params)
  } catch (error) {
    console.error(error)
    return path
  }
}
