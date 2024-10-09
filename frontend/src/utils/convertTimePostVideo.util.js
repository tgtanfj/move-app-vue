export const convertTimePostVideo = (timestamp) => {
  const now = new Date()
  const timeDifference = now - new Date(timestamp * 1000) 
  const seconds = Math.floor(timeDifference / 1000)
  const minutes = Math.floor(seconds / 60)
  const hours = Math.floor(minutes / 60)
  const days = Math.floor(hours / 24)
  const weeks = Math.floor(days / 7)
  const months = Math.floor(days / 30) 
  const years = Math.floor(days / 365) 

  if (hours < 24) {
    return 'Most recent (Within 24 hours)'
  } else if (days === 1) {
    return 'Posted a day ago'
  } else if (days > 1 && days <= 6) {
    return `Posted ${days} days ago`
  } else if (weeks === 1) {
    return 'A week ago'
  } else if (weeks > 1 && weeks <= 4) {
    return `${weeks} weeks ago`
  } else if (months === 1) {
    return 'A month ago'
  } else if (months > 1 && months < 12) {
    return `${months} months ago`
  } else if (years === 1) {
    return '1 year ago'
  } else {
    return `${years} years ago`
  }
}

export const convertTimeComment = (timestamp) => {
  const now = new Date()
  const timeDifference = now - new Date(timestamp * 1000) 
  const seconds = Math.floor(timeDifference / 1000)
  const minutes = Math.floor(seconds / 60)
  const hours = Math.floor(minutes / 60)
  const days = Math.floor(hours / 24)
  const weeks = Math.floor(days / 7)
  const months = Math.floor(days / 30)
  const years = Math.floor(days / 365)

  if (seconds < 60) {
    return `${seconds} seconds ago`
  } else if (minutes < 60) {
    return `${minutes} minutes ago`
  } else if (hours < 24) {
    return `${hours} hours ago`
  } else if (days < 7) {
    return `${days} days ago`
  } else if (weeks < 5) {
    return `${weeks} weeks ago`
  } else if (months < 12) {
    return `${months} months ago`
  } else {
    return years === 1 ? '1 year ago' : `${years} years ago`
  }
}

