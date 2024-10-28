const socialOrder = ['facebook', 'instagram', 'youtube']

export const sortedSocialLinks = (links) => {
  return links.slice().sort((a, b) => {
    return socialOrder.indexOf(a.name.toLowerCase()) - socialOrder.indexOf(b.name.toLowerCase())
  })
}
