import Cookies from 'js-cookie'
import { COOKIE_EXPIRED_TIME } from '@constants/cookies.constant'

export const setCookie = (name, value, options = {}) => {
  const expireTime = parseInt(process.env.VITE_COOKIE_EXPIRE_TIME, 10) || COOKIE_EXPIRED_TIME
  Cookies.set(name, value, { expires: expireTime, ...options })
}

export const removeAllCookies = () => {
  const cookies = document.cookie.split(';')

  for (let i = 0; i < cookies.length; i++) {
    const cookie = cookies[i]
    const eqPos = cookie.indexOf('=')
    const name = eqPos > -1 ? cookie.slice(0, eqPos) : cookie.trim()
    document.cookie = `${name}=;expires=Thu, 01 Jan 1970 00:00:00 GMT;path=/;`
  }
}
