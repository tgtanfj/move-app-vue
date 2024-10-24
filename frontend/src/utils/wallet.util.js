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
