import {
  REGEX_CONVERT_CATEGORY_TITLE_TO_URL_FIRST,
  REGEX_CONVERT_CATEGORY_TITLE_TO_URL_SECOND,
  REGEX_CONVERT_URL_TO_CATEGORY_TITLE
} from '@constants/regex.constant'

export const formatCategoryTitleToUrl = (str) => {
  return str
    .toLowerCase()
    .replace(REGEX_CONVERT_CATEGORY_TITLE_TO_URL_FIRST, '-')
    .replace(REGEX_CONVERT_CATEGORY_TITLE_TO_URL_SECOND, '')
}

export const formatUrlToCategoryTitle = (str) => {
  return str.replace(REGEX_CONVERT_URL_TO_CATEGORY_TITLE, ' ').toUpperCase()
}
