import _, { get, set } from 'lodash';
import { getCookie, setCookie } from 'cookies-next';
import Cookies from 'js-cookie';

import { constants } from '@/settings';

const webStorageClient = {
  set(key: string, rawValue: any, option?: any) {
    const value = _.isString(rawValue) ? rawValue : JSON?.stringify(rawValue);
    setCookie(key, value, option);
  },

  get(key: string) {
    const value: string = getCookie(key) || '';
    try {
      return JSON?.parse(value);
    } catch {
      return value;
    }
  },

  remove(key: string) {
    setCookie(key, null, { maxAge: 0 });
  },

  removeAll() {
    Object.keys(Cookies.get()).forEach((cookieName) => {
      Cookies.remove(cookieName);
    });
  },

  setToken(value: string, option?: any) {
    setCookie(constants.ACCESS_TOKEN, value, option);
  },

  getToken() {
    return getCookie(constants.ACCESS_TOKEN);
  },

  setUserInfo(value: any, option?: any) {
    setCookie(constants.USER_INFO, value, option);
  },
  getUserInfo() {
    return getCookie(constants.USER_INFO);
  }
};

export default webStorageClient;
