export const normalizeGender = (gender) => {
  if (gender === 'male') return 'M'
  if (gender === 'female') return 'F'
  return 'O'
}
export const denormalizeGender = (gender) => {
  if (gender === 'M') return 'male'
  if (gender === 'F') return 'female'
  if (gender === 'O') return 'rather not say'
  return ''
}
