import { MONTHS } from '@constants/date.constant'

export const validateCard = async (card, stripe, cardError) => {
  const cardElement = card.value
  const { error } = await stripe.value.createToken(cardElement)
  if (error) {
    cardError.value = error.message
    return false
  } else {
    cardError.value = ''
    return true
  }
}
export const formatDateToDDMMMYYYY = (date) => {
  const day = String(date.getDate()).padStart(2, '0')
  const monthIndex = date.getMonth()
  const year = date.getFullYear()

  const monthName = MONTHS[monthIndex].text

  return `${day} ${monthName} ${year}`
}
