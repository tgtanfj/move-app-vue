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

export const hasEmptyProperty = (obj) => {
  for (let key in obj) {
    if (obj.hasOwnProperty(key)) {
      if (key === 'city' || key === 'cardType' || key === 'channelId') {
        continue
      }

      const value = obj[key]
      if (value === undefined || value === null || value === '') {
        return true
      }
    }
  }
  return false
}

export const profileUpdated = (currentProfile, newProfile) => {
  for (const key in currentProfile) {
    if (key === 'country') {
      if (currentProfile[key].name !== newProfile[key]) {
        return true
      }
    } else if (key === 'state') {
      if (currentProfile[key].name !== newProfile[key]) {
        return true
      }
    } else {
      if (currentProfile[key] !== newProfile[key]) {
        return true
      }
    }
  }
  return false
}
